//
//  MapCollectionViewCell.swift
//  InMotion
//
//  Created by Michael Carter and Patricie Suppala on 29.4.2021.
//

import UIKit
import MapKit
import Polyline
import CoreLocation


// Displays interactiove map on a collection cell and draws polylines
class MapCollectionViewCell: UICollectionViewCell, MKMapViewDelegate {
    
    static var identifier = "MapCollectionViewCell"
    var dictOfPolylines: [String?: String?] = [:]
    let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
    let polylineIfNil = "kr_nJcngvC"
    let modeIfNil = "unknown"
    var mode:String?
    var journey: Journey!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with journey: Journey){
        
        // Drawing journey and points of interest into a map
        
        for s in journey.journeySegment ?? [] {
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
        for p in journey.posts ?? [] {
            
            let y = p as! Post
            
            let postCoordinates: CLLocationCoordinate2D? = CLLocationCoordinate2D( latitude: y.postLat, longitude: y.postLong)
            
            
            //render post from the main thread
            DispatchQueue.main.async{
                self.createPostPOI(postCoordinates : postCoordinates ?? self.pointIfNil, title: y.postTitle ?? "", subtitle: y.postBlog ?? "" )
            }
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MapCollectionViewCell", bundle: nil)
    }
    
    // Func for rendering polyline
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        //print("MODE in mapView: ", mode!)
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
        
        if let location = sourcePlaceMark.location {
            sourceAnotation.coordinate = location.coordinate
        }
        
        let destinationAnotation = MKPointAnnotation()
        destinationAnotation.title = "finish"
        
        if let location = destinationPlaceMark.location {
            destinationAnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
        
        let rect = polylineTwo.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        mapView.addOverlay(polylineTwo)
        
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
        
    }
    
}
