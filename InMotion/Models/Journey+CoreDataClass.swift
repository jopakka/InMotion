//
//  Journey+CoreDataClass.swift
//  InMotion
//
//  Created by iosdev on 15.4.2021.
//
//

import Foundation
import CoreData


public class Journey: NSManagedObject {

    class func createNewJourney(context: NSManagedObjectContext) -> Journey?  {
        let uuid = UUID()
        let journey = Journey(context: context)
        journey.journeyId = uuid
        journey.journeyStarted = Date()
        return journey
    }
}
