//
//  MoprimApi.swift
//  InMotion
//
//  Created by iosdev on 14.4.2021.
//
//

import Foundation
import MOPRIMTmdSdk

class MoprimApi {
    static let instance = MoprimApi()
    
    func fetchData(date: Date) {
        TMDCloudApi.fetchData(date, minutesOffset: 0.0).continueOnSuccessWith { task in
            DispatchQueue.main.async {
                if let error = task.error {
                    NSLog("fetchData error: %@", error.localizedDescription)
                } else if let data = task.result, data.count > 0 {
                    print(data)
                    print("data date: \((data[0] as! TMDActivity).timestampStart)")
                    for d in data {
                        let x = d as! TMDActivity
                        print("x: \(x)")
                        print(" other test words")
                    }
                }
            }
        }
    }
    
    // This function is usually called when one wants to know what data can be fetched from the Cloud
    
    //    fetchMetadata result: {
    //    firstUploadTimestamp: -1,
    //    lastTmdTimestamp: -1,
    //    lastTmdMovingActivityTimestamp: -1,
    //    lastLocationTimestamp: -1,
    //    _lastTmdUploadTimestamp: -1,
    //    lastLocationUploadTimestamp: -1,
    //    communityDailyCo2:-1.000000,
    //    communityDailyDistance:-1.000000,
    //    communityDailyDuration:-1.000000}
    
    func fetchMetadata(){
        TMDCloudApi.fetchMetadata().continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                // Execute your UI related code on the main thread
                if let error = task.error {
                    NSLog("fetchMetadata Error: %@", error.localizedDescription)
                }
                else if let metadata = task.result {
                    NSLog("fetchMetadata result: %@", metadata)
                    print(metadata)
                }
            }
            return nil;
        }
    }
}
