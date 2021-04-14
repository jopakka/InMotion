//
//  Journey+CoreDataProperties.swift
//  InMotion
//
//  Created by iosdev on 14.4.2021.
//
//

import Foundation
import CoreData


extension Journey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Journey> {
        return NSFetchRequest<Journey>(entityName: "Journey")
    }

    @NSManaged public var journeyName: String?
    @NSManaged public var journeyStarted: Date?
    @NSManaged public var journeyEnded: Date?
    @NSManaged public var journeyId: UUID?
    @NSManaged public var user: User?
    @NSManaged public var journeySegment: NSSet?

}

// MARK: Generated accessors for journeySegment
extension Journey {

    @objc(addJourneySegmentObject:)
    @NSManaged public func addToJourneySegment(_ value: JourneySegment)

    @objc(removeJourneySegmentObject:)
    @NSManaged public func removeFromJourneySegment(_ value: JourneySegment)

    @objc(addJourneySegment:)
    @NSManaged public func addToJourneySegment(_ values: NSSet)

    @objc(removeJourneySegment:)
    @NSManaged public func removeFromJourneySegment(_ values: NSSet)

}

extension Journey : Identifiable {

}
