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
    
    func generateTripToMoprim() {
        let start = CLLocation(latitude: 60.227528, longitude: 24.7065193)
        let end = CLLocation(latitude: 60.219879, longitude: 24.6653063)
        
        TMDCloudApi.generateSyntheticData(withOriginLocation: start, destination: end, requestType: .bicycle, hereApiKey: "SECRET").continueWith { task in
            if let error = task.error {
                print("error: ", error.localizedDescription)
            } else if let data = task.result {
                print("result: ", data)
            }
            return nil
        }
    }
}
