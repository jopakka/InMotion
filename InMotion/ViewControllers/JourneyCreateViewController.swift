//
//  JourneyCreateViewController.swift
//  InMotion
//
//  Created by iosdev on 19.4.2021.
//

import UIKit
import Foundation
import MapKit

class JourneyCreateViewController: UIViewController {

  
    @IBOutlet weak var map: MKMapView!
   
    
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        print("A")
        //locationManager.requestAlwaysAuthorization()
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("B")
        locationManager.distanceFilter = kCLDistanceFilterNone
        print("C")
        locationManager.startUpdatingLocation()
        print("D")
        map.showsUserLocation = true
        print("E")
    }
}


