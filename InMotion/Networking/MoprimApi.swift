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
                } else if let data = task.result {
                    print(data)
                    print("test words")
                    for d in data {
                        let x = d as! TMDActivity
                        print("x: \(x)")
                        print(" other test words")
                    }
                }
            }
        }
    }
    
    func fetchStats() {
        TMDCloudApi.fetchMetadata().continueOnSuccessWith { task in
            DispatchQueue.main.async {
                if let error = task.error {
                    NSLog("fetchData error: %@", error.localizedDescription)
                } else if let data = task.result {
                    print(data)
                }
            }
        }
    }
}
