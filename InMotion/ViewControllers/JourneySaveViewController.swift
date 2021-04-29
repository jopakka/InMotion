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
    
    
    let yesterday = Date().advanced(by: -86400)
    let polyline = Polyline(encodedPolyline: "qkqtFbn_Vui`Xu`l]")
    var journey: Journey?
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNewBackButton()
        
        print(yesterday)
        print(Date())
        
        MoprimApi.instance.fetchData(date: yesterday)
        let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
        print(decodedCoordinates ?? [])
        
        // mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = false
       
        let polyline = MKPolyline(coordinates: decodedCoordinates ?? [], count: decodedCoordinates?.count ?? 0)
        mapView.addOverlay(polyline)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // affects battery
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        
    }
    
    private func setNewBackButton() {
        // https://stackoverflow.com/a/27713813
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // https://stackoverflow.com/a/27713813
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("back works !!!!")
        navigationController?.popViewController(animated: false)
    }
    
    
    
}

extension JourneySaveViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
     
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let pathRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        pathRenderer.strokeColor = .blue
        pathRenderer.lineWidth = 5
        pathRenderer.alpha = 0.85
        
        return pathRenderer
    }
}


