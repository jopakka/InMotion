//
//  Post+CoreDataProperties.swift
//  InMotion
//
//  Created by iosdev on 14.4.2021.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var postTitle: String?
    @NSManaged public var postBlog: String?
    @NSManaged public var postImage: String?
    @NSManaged public var postLongCoord: String?
    @NSManaged public var postLatCoord: String?
    @NSManaged public var journeySegment: JourneySegment?

}

extension Post : Identifiable {

}
