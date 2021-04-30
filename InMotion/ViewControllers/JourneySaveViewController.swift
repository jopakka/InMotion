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
    
    let yesterday = Date().advanced(by: -86400)
    let polyline = Polyline(encodedPolyline: "{yd~FnvfvO{eE_uJo|FlfAhm@fbEjxE{pCuzBr`K")
    let pointIfNil = CLLocationCoordinate2D(latitude: 40.23497, longitude: -3.77074)
    var journey: Journey!

    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNewBackButton()
        
        // fetching the route that we want to display
        MoprimApi.instance.saveDataToCore(date: Date(), journey: journey, context: AppDelegate.viewContext)
        
        // decoding coordinates
        let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
        
        //render trail
        createPath(decodedCoordinates : decodedCoordinates ?? [pointIfNil])
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let rendere = MKPolylineRenderer(overlay: overlay)
        rendere.lineWidth = 5
        rendere.strokeColor = .systemBlue
        return rendere
    }
    
    func createPath(decodedCoordinates : [CLLocationCoordinate2D]) {
        mapView.delegate = self
        let polylineTwo = MKPolyline(coordinates: decodedCoordinates , count: decodedCoordinates.count )
        
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
        
        // show whole route
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
     
        
        let rect = polylineTwo.boundingMapRect
        self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        mapView.addOverlay(polylineTwo)
      
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
