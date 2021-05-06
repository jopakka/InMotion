//
//  JourneyTrackViewController.swift
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

class JourneyTrackViewController: UIViewController, MKMapViewDelegate {
    
    var arrayOfLocations = [CLLocationCoordinate2D]()
    var currentJourney: Journey!
    let journeyStartTime = Date()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func saveJourneyButton(_ sender: UIButton) {
        // Uncomment for testing on device
        TMD.stop()
        let managedContext = AppDelegate.viewContext
        currentJourney.journeyEnded = Date()
        do {
            try managedContext.save()
        } catch {
            NSLog("Failed to save journey end to core")
        }
        performSegue(withIdentifier: "saveJourney", sender: self)
    }
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate let motionActivityManager = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layer.zPosition = 0
        // I think this is safe to delete
        //Uncomment this for testing on device
//        TMD.start()
//        TMD.setAllowUploadOnCellularNetwork(true)
//        let firstUploadTime = Date() // format 2021-04-25 14:10:18 +0000

        NSLog(TMD.isOn() ? "TMD is ON" : "TMD is OFF")
        navigationItem.hidesBackButton = true
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //other permissions we might want to use
        //locationManager.requestAlwaysAuthorization()
        //locationManager.allowsBackgroundLocationUpdates = true
        //locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // affects battery
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? JourneySaveViewController {
            destVC.journey = currentJourney
        } else if let destVC = segue.destination as? AddMemoryViewController {
            destVC.journey = currentJourney
            destVC.location = mapView.userLocation.location
        }
    }
}

extension JourneyTrackViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        arrayOfLocations.append(locations.last!.coordinate)
        
        
        if arrayOfLocations.count>0 {
            
            let polyline = MKPolyline(coordinates: arrayOfLocations, count: arrayOfLocations.count)
            mapView.addOverlay(polyline)
        } else {
            print("waiting")
        }
        
       
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let pathRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        pathRenderer.strokeColor = .blue
        pathRenderer.lineWidth = 5
        pathRenderer.alpha = 0.85
        
        return pathRenderer
    }
}


