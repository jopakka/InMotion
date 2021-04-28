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
            
        }
    }
}
