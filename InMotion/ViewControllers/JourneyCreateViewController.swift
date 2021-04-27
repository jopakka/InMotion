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

class JourneyCreateViewController: UIViewController{
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var startJourneyButton: UIButton!
    
    
    fileprivate let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //other permissions we might want to use
        //locationManager.requestAlwaysAuthorization()
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // affects battery
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
}

extension JourneyCreateViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
    }
    
    
}
