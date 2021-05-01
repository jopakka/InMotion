//
//  Post+CoreDataProperties.swift
//  InMotion
//
//  Created by iosdev on 1.5.2021.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var postBlog: String?
    @NSManaged public var postLatCoord: String?
    @NSManaged public var postLongCoord: String?
    @NSManaged public var postTitle: String?
    @NSManaged public var postId: UUID?
    @NSManaged public var postTime: Date?
    @NSManaged public var postImg: Data?
    @NSManaged public var journey: Journey?

}

extension Post : Identifiable {

}
