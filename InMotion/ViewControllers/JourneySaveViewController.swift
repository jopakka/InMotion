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
    
    
    let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
    let polylineIfNil = "kr_nJcngvC"
    let modeIfNil = "unknown"
    var mode:String? = "unknown"
    var journey: Journey!
    
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNewBackButton()
        // Use only with emulator
        //        CustomLocation.instance.generateTripToMoprim().continueWith { task in
        //            print("trip saved")
        //            // fetching the route that we want to display
        MoprimApi.instance.saveDataToCore(date: Date(), journey: self.journey, context: AppDelegate.viewContext).continueWith { task in
            print("data saved")
            print("journey: ", self.journey)
            
            // Drawing journey and points of interest into a map
            
            for j in self.journey.journeySegment ?? [] {
                print("LOOPING")
                let x = j as! JourneySegment
                
                let polyline = Polyline(encodedPolyline: x.segmentEncodedPolyLine ?? self.polylineIfNil)
                self.mode = x.segmentModeOfTravel ?? self.modeIfNil
                print("MODE in Segment: ", self.mode)
                let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
                
                //render trail from the main thread
                DispatchQueue.main.async{
                    self.createPath(decodedCoordinates : decodedCoordinates ?? [self.pointIfNil], mode: self.mode ?? self.modeIfNil )
                }
                
                //fetch memories
                // ...add code here...
            }
            return nil
        }
        //            return nil
        //        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        print("MODE in mapView: ", mode)
        switch mode {
        case "stationary"?:
            rendere.strokeColor = .systemGray2
        case "walk"?:
            rendere.strokeColor = .systemGreen
        case "car"?:
            rendere.strokeColor = .systemRed
        case "bus"?:
            rendere.strokeColor = .systemOrange
        case "bicycle"?:
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
    
    func createPath(decodedCoordinates : [CLLocationCoordinate2D], mode : String) {
        mapView.delegate = self
        
       
        
        let polylineTwo = MKPolyline(coordinates: decodedCoordinates , count: decodedCoordinates.count )
        
      //  MKPolylineRenderer(overlay: polylineTwo).lineWidth = 5
       // MKPolylineRenderer(overlay: polylineTwo).strokeColor = .systemRed
        
        let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
        
        // set annotations for start and end points
        let sourceLocation = decodedCoordinates.first ?? pointIfNil
        let destinationLocation = decodedCoordinates.last ?? pointIfNil
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let sourceAnotation = MKPointAnnotation()
        //sourceAnotation.title = ""
        //sourceAnotation.subtitle = ""
        if let location = sourcePlaceMark.location {
            sourceAnotation.coordinate = location.coordinate
        }
        
        let destinationAnotation = MKPointAnnotation()
        //destinationAnotation.title = ""
        //destinationAnotation.subtitle = ""
        if let location = destinationPlaceMark.location {
            destinationAnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnotation, destinationAnotation], animated: true)
        
        // show segment´s route
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let rect = polylineTwo.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        mapView.addOverlay(polylineTwo)
        print("PATH DRAWN SUCCESSFULLY")
    }
    
    private func setNewBackButton() {
        // https://stackoverflow.com/a/27713813
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // https://stackoverflow.com/a/27713813
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("back works !!!!")
        
        guard let n = getTrimmedTexts(), n.count > 0 else {
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "Name can't be empty", presenter: self)
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
