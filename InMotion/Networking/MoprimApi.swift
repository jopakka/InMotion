//
//  MoprimApi.swift
//  InMotion
//
//  Created by iosdev on 14.4.2021.
//
//

import Foundation
import MOPRIMTmdSdk
import CoreData

class MoprimApi {
    static let instance = MoprimApi()
    
    func saveDataToCore(date: Date, journey: Journey, context: NSManagedObjectContext) -> TMDTask<AnyObject> {
        return TMDCloudApi.fetchData(date, minutesOffset: 0.0).continueOnSuccessWith { task in
            if let error = task.error {
                NSLog("fetchData error: %@", error.localizedDescription)
            } else if let data = task.result, data.count > 0 {
                for d in data {
                    let segment = JourneySegment(context: context)
                    let x = d as! TMDActivity
                    let dateConventer = DateHelper.instance
                    segment.segmentDistanceTravelled = Int64(x.distance)
                    segment.segmentStart = dateConventer.timeStampToDate(x.timestampStart)
                    let endTime = dateConventer.timeStampToDate(x.timestampEnd)
                    segment.segmentEnd = endTime
                    segment.segmentModeOfTravel = x.activity()
                    segment.segmentEncodedPolyLine = x.polyline
                    segment.segmentCo2 = x.co2
                    journey.addToJourneySegment(segment)
                }
                
                do {
                    try context.save()
                    NSLog("journey saved")
                } catch {
                    NSLog("SaveDataToCore error: ", error.localizedDescription)
                }
            }
            return nil
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
