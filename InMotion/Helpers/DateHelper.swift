//
//  DateHelper.swift
//  InMotion
//
//  Created by iosdev on 30.4.2021.
//

import Foundation

class DateHelper {
    static let instance = DateHelper()
    
    func timeStampToDate(_ timeStamp: Int64) -> Date {
        let date = Date(timeIntervalSince1970: Double(timeStamp / 1000))
        return date
    }
}
