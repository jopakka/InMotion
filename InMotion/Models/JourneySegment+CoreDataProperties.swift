//
//  JourneySegment+CoreDataProperties.swift
//  InMotion
//
//  Created by iosdev on 1.5.2021.
//
//

import Foundation
import CoreData


extension JourneySegment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JourneySegment> {
        return NSFetchRequest<JourneySegment>(entityName: "JourneySegment")
    }

    @NSManaged public var segmentAverageSpeed: Int64
    @NSManaged public var segmentCo2: Double
    @NSManaged public var segmentDestination: String?
    @NSManaged public var segmentDistanceTravelled: Int64
    @NSManaged public var segmentEncodedPolyLine: String?
    @NSManaged public var segmentEnd: Date?
    @NSManaged public var segmentModeOfTravel: String?
    @NSManaged public var segmentOrigin: String?
    @NSManaged public var segmentStart: Date?
    @NSManaged public var journey: Journey?

}

extension JourneySegment : Identifiable {

}
