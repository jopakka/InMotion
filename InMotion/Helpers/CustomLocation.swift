//
//  CustomLocation.swift
//  InMotion
//
//  Created by iosdev on 30.4.2021.
//

import Foundation
import CoreData
import MOPRIMTmdSdk

class CustomLocation {
    static let instance = CustomLocation()
    
    func generateTripToMoprim() -> TMDTask<AnyObject> {
        let start = CLLocation(latitude: 60.227528, longitude: 24.7065193)
        let end = CLLocation(latitude: 55.019879, longitude: 24.6653063)
        
        return TMDCloudApi.generateSyntheticData(withOriginLocation: start, destination: end, requestType: .bicycle, hereApiKey: ProcessInfo.processInfo.environment["HERE_API"]!).continueWith { task in
            if let error = task.error {
                print("error: ", error.localizedDescription)
            } else if let data = task.result {
                print("result: ", data)
            }
            return task
        }
    }
}
