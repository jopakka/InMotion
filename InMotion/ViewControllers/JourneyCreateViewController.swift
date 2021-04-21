//
//  JourneyCreateViewController.swift
//  InMotion
//
//  Created by iosdev on 19.4.2021.
//

import UIKit
import Foundation
import MapKit
import CoreLocation

class JourneyCreateViewController: UIViewController, CLLocationManagerDelegate{

  
    @IBOutlet weak var map: MKMapView!
   
    @IBOutlet weak var startJourneyButton: UIButton!
    
    fileprivate let manager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest // affects battery
        manager.distanceFilter = kCLDistanceFilterNone
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
           //done like this it just checks the current location, if the person is moving, it does not register the movement
            manager.startUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location: CLLocation){
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        map.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        map.addAnnotation(pin)
    }
}


