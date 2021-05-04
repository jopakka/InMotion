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
    
    var journey: Journey!
    
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
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            
            case .restricted, .denied:
                let alert = UIAlertController(title: NSLocalizedString("Location services are disabled. In order to record a journey you need to go to settings and enable location for InMotion app", comment: "Cannot proceed without permissions"), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Back home", comment: "Do not change settings"), style: .destructive, handler: { action in
                    
                    // Take user to home screen
                    let board = UIStoryboard(name: "Main", bundle: nil)
                    let vc = board.instantiateViewController(identifier: "MainTab")
                    let win = UIApplication.shared.windows.first
                    win?.rootViewController = vc
                    win?.makeKeyAndVisible()
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }))
                alert.addAction(UIAlertAction(title: "Take me to settings", style: .cancel, handler: { action in
                    
                    // This will open your app settings in settings App
                    let url = URL(string:UIApplication.openSettingsURLString)
                    if UIApplication.shared.canOpenURL(url!){
                        // can open succeeded.. opening the url
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                    
                }))
                self.present(alert, animated: true)
                
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.desiredAccuracy = kCLLocationAccuracyBest // affects battery
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.startUpdatingLocation()
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    @IBAction func startJourneyAction(_ sender: UIButton) {
        TMD.start()
        let managedContext = AppDelegate.viewContext
        
        guard let user = UserHelper.instance.getUser() else {
            // Ideally this should take user back to login screen
            return
        }
        journey = Journey.createNewJourney(user: user ,context: managedContext)
        performSegue(withIdentifier: "trackJourney", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as? JourneyTrackViewController
        destVC?.currentJourney = journey
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
