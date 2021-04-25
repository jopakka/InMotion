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
    
    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate let motionActivityManager = CMMotionActivityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TMD.start()
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
        
        func askMotionPermissions() {
            if CMMotionActivityManager.isActivityAvailable() {
                self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                    print("received motion activity")
                    self.motionActivityManager.stopActivityUpdates()
                }
            }
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

