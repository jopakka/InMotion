//
//  JourneySegment+CoreDataProperties.swift
//  InMotion
//
//  Created by iosdev on 15.4.2021.
//
//

import Foundation
import CoreData


extension JourneySegment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JourneySegment> {
        return NSFetchRequest<JourneySegment>(entityName: "JourneySegment")
    }

    @NSManaged public var segmentAverageSpeed: Int64
    @NSManaged public var segmentCarbonDioxideValue: Int64
    @NSManaged public var segmentDestination: String?
    @NSManaged public var segmentDistanceTravelled: Int64
    @NSManaged public var segmentEncodedPolyLine: String?
    @NSManaged public var segmentEnd: Date?
    @NSManaged public var segmentModeOfTravel: String?
    @NSManaged public var segmentOrigin: String?
    @NSManaged public var segmentStart: Date?
    @NSManaged public var journey: Journey?
    @NSManaged public var post: NSSet?

}

// MARK: Generated accessors for post
extension JourneySegment {

    @objc(addPostObject:)
    @NSManaged public func addToPost(_ value: Post)

    @objc(removePostObject:)
    @NSManaged public func removeFromPost(_ value: Post)

    @objc(addPost:)
    @NSManaged public func addToPost(_ values: NSSet)

    @objc(removePost:)
    @NSManaged public func removeFromPost(_ values: NSSet)

}

extension JourneySegment : Identifiable {

}
