//
//  User+CoreDataProperties.swift
//  InMotion
//
//  Created by iosdev on 15.4.2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var avatarImg: Data?
    @NSManaged public var bannerImg: Data?
    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var password: String?
    @NSManaged public var username: String?
    @NSManaged public var journey: NSSet?

}

// MARK: Generated accessors for journey
extension User {

    @objc(addJourneyObject:)
    @NSManaged public func addToJourney(_ value: Journey)

    @objc(removeJourneyObject:)
    @NSManaged public func removeFromJourney(_ value: Journey)

    @objc(addJourney:)
    @NSManaged public func addToJourney(_ values: NSSet)

    @objc(removeJourney:)
    @NSManaged public func removeFromJourney(_ values: NSSet)

}

extension User : Identifiable {

}
