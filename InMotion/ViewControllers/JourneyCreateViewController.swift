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
import CoreMotion
import MOPRIMTmdSdk

class JourneyCreateViewController: UIViewController{
    
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var startJourneyButton: UIButton!
    
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate let motionActivityManager = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TMD.setAllowUploadOnCellularNetwork(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        askLocationPermissions()
        askMotionPermissions()
    }
    
    func askMotionPermissions() {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                print("received motion activity")
                self.motionActivityManager.stopActivityUpdates()
            }
        }
    }
    
    func askLocationPermissions() {
        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        other permissions we might want to use
        locationManager.requestAlwaysAuthorization()
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // affects battery
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func startJourneyAction(_ sender: UIButton) {
        TMD.start()
        performSegue(withIdentifier: "trackJourney", sender: self)
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
