//
//  JourneySaveViewController.swift
//  InMotion
//
//  Created by iosdev on 22.4.2021.
//

import Foundation
import UIKit
import MOPRIMTmdSdk
import CoreLocation
import Polyline
import MapKit

class JourneySaveViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var favouriteSwitch: UISwitch!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
    let polylineIfNil = "kr_nJcngvC"
    let modeIfNil = "unknown"
    var mode:String? = "unknown"
    var journey: Journey!
    var imageArray = [Post]()
    var post: Post!
    
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNewBackButton()
        // Use only with emulator
        CustomLocation.instance.generateTripToMoprim().continueWith { task in
            
            // fetching the route that we want to display
            MoprimApi.instance.saveDataToCore(date: Date(), journey: self.journey, context: AppDelegate.viewContext).continueWith { task in
                
                // Drawing journey and points of interest into a map
                
                for s in self.journey.journeySegment ?? [] {
                    
                    let x = s as! JourneySegment
                    
                    let polyline = Polyline(encodedPolyline: x.segmentEncodedPolyLine ?? self.polylineIfNil)
                    self.mode = x.segmentModeOfTravel ?? self.modeIfNil
                    
                    let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
                    
                    //render trail from the main thread
                    DispatchQueue.main.async{
                        self.createPath(decodedCoordinates : decodedCoordinates ?? [self.pointIfNil], mode: self.mode ?? self.modeIfNil )
                    }
                }
                
                //fetch memories
                for p in self.journey.posts ?? [] {
                    let y = p as! Post
                    
                    self.imageArray.append(y)
                    let postCoordinates: CLLocationCoordinate2D? = CLLocationCoordinate2D( latitude: y.postLat, longitude: y.postLong)
                    
                    //render post from the main thread
                    DispatchQueue.main.async{
                        self.collectionView.reloadData()
                        self.createPostPOI(postCoordinates : postCoordinates ?? self.pointIfNil, title: y.postTitle ?? "", subtitle: y.postBlog ?? "" )
                    }
                }
                return nil
            }
            return nil
        }
        
        collectionView.setCollectionViewLayout(JourneySaveViewController.createLayout(), animated: true)
        collectionView.register(ImagePostCollectionViewCell.nib(), forCellWithReuseIdentifier: ImagePostCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // collection view layout func
    
    static func createImageLayout() -> NSCollectionLayoutSection{
        //item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)
            )
        )
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2)
        
        
        //group
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ),
            subitem: verticalStackItem,
            count: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(3/5)),
            subitems: [
                item,
                verticalGroup
            ]
        )
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            return self.createImageLayout()
        }
    }
    
    
    // Func for rendering polyline
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        
        switch mode {
        case "stationary"?:
            rendere.strokeColor = .systemGray2
        case "walk"?:
            rendere.strokeColor = .systemGreen
        case "car"?:
            rendere.strokeColor = .systemRed
        case "bus"?:
            rendere.strokeColor = .systemOrange
        case "non-motorized/bicycle"?:
            rendere.strokeColor = .systemBlue
        case "pedestrian"?:
            rendere.strokeColor = .systemPurple
        case "run"?:
            rendere.strokeColor = .systemIndigo
        case "rail"?:
            rendere.strokeColor = .systemTeal
        case "tram"?:
            rendere.strokeColor = .systemYellow
        case "train"?:
            rendere.strokeColor = .systemYellow
        case "metro"?:
            rendere.strokeColor = .systemOrange
        case "plane"?:
            rendere.strokeColor = .systemBlue
        case "road"?:
            rendere.strokeColor = .systemIndigo
        case "motorized"?:
            rendere.strokeColor = .systemPurple
        case "non-motorized"?:
            rendere.strokeColor = .systemPink
        case "water"?:
            rendere.strokeColor = .systemBlue
        default:
            rendere.strokeColor = .systemGray
        }
        
        return rendere
    }
    
    // Func for point on a map baloon shape
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        }
        
        if let title = annotation.title, title == "start" || title == "finish" {
            switch mode {
            case "stationary"?:
                annotationView?.image = UIImage(named: "flagman")
            case "walk"?:
                annotationView?.image = UIImage(named: "pedestriancrossing")
            case "car"?:
                annotationView?.image = UIImage(named: "car")
            case "bus"?:
                annotationView?.image = UIImage(named: "bus")
            case "non-motorized/bicycle"?:
                annotationView?.image = UIImage(named: "cycling")
            case "pedestrian"?:
                annotationView?.image = UIImage(named: "pedestriancrossing")
            case "run"?:
                annotationView?.image = UIImage(named: "pedestriancrossing")
            case "rail"?:
                annotationView?.image = UIImage(named: "train")
            case "tram"?:
                annotationView?.image = UIImage(named: "tramway")
            case "train"?:
                annotationView?.image = UIImage(named: "train")
            case "metro"?:
                annotationView?.image = UIImage(named: "underground")
            case "plane"?:
                annotationView?.image = UIImage(named: "airport")
            case "road"?:
                annotationView?.image = UIImage(named: "vespa")
            case "motorized"?:
                annotationView?.image = UIImage(named: "sportutilityvehicle")
            case "non-motorized"?:
                annotationView?.image = UIImage(named: "flagman")
            case "water"?:
                annotationView?.image = UIImage(named: "boat")
            default:
                annotationView?.image = UIImage(named: "flagman")
            }
            
        } else  {
            annotationView?.image = UIImage(named: "photo")
        }
        
        
        
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    // Func for point on a map baloon shape
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("The annotation was selected: \(String(describing: view.annotation?.title))")
    }
    
    func createPath(decodedCoordinates : [CLLocationCoordinate2D], mode : String) {
        mapView.delegate = self
        
        let polylineTwo = MKPolyline(coordinates: decodedCoordinates , count: decodedCoordinates.count )
        
        let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
        
        // set annotations for start and end points
        let sourceLocation = decodedCoordinates.first ?? pointIfNil
        let destinationLocation = decodedCoordinates.last ?? pointIfNil
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceAnotation = MKPointAnnotation()
        sourceAnotation.title = "start"
        //sourceAnotation.subtitle = ""
        if let location = sourcePlaceMark.location {
            sourceAnotation.coordinate = location.coordinate
        }
        
        let destinationAnotation = MKPointAnnotation()
        destinationAnotation.title = "finish"
        //destinationAnotation.subtitle = ""
        if let location = destinationPlaceMark.location {
            destinationAnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
        
        let rect = polylineTwo.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        mapView.addOverlay(polylineTwo)
        print("PATH DRAWN SUCCESSFULLY")
    }
    
    func createPostPOI(postCoordinates : CLLocationCoordinate2D, title : String, subtitle : String) {
        mapView.delegate = self
        let postPlaceMark = MKPlacemark(coordinate: postCoordinates, addressDictionary: nil)
        let postAnotation = MKPointAnnotation()
        
        postAnotation.title = title
        postAnotation.subtitle = subtitle
        if let location = postPlaceMark.location {
            postAnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([postAnotation], animated: true)
        print("POST POI DRAWN SUCCESSFULLY")
    }
    
    private func setNewBackButton() {
        // https://stackoverflow.com/a/27713813
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // https://stackoverflow.com/a/27713813
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        
        guard let n = getTrimmedTexts(), n.count > 0 else {
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("no_name", comment: ""), presenter: self)
            return
        }
        
        journey.journeyName = n
        journey.favourite = favouriteSwitch.isOn
        
        let managedContext = AppDelegate.viewContext
        try? managedContext.save()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getTrimmedTexts() -> String? {
        // Check if text fields have text
        guard var n = nameTf.text else {
            return nil
        }
        
        // Trim text fields
        n = n.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return n
    }
}

extension JourneySaveViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePostCollectionViewCell.identifier, for: indexPath) as! ImagePostCollectionViewCell
        
        cell.imageView.image = UIImage(data:imageArray[indexPath.row].postImg!)
        return cell
    }
    
    
}

extension JourneySaveViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image pressed")
        post = imageArray[indexPath.row]
        performSegue(withIdentifier: "editJourneyImages", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editJourneyImages" {
            
            let destVC = segue.destination as! JourneyMediaDetailsViewController
            destVC.receivedPost = post!
        }
        
    }
}


