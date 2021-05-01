//
//  Post+CoreDataClass.swift
//  InMotion
//
//  Created by iosdev on 15.4.2021.
//
//

import Foundation
import CoreData


public class Post: NSManagedObject {

    class func createNewPost(title: String, blog: String, imgData: Data, location: CLLocation, journey: Journey, context: NSManagedObjectContext) -> Post? {
        let post = Post(context: context)
        post.postId = UUID()
        post.postTitle = title
        post.postBlog = blog
        post.postImg = imgData
        post.postTime = Date()
        post.postLong = location.coordinate.longitude
        post.postLat = location.coordinate.latitude
        journey.addToPosts(post)
        
        do {
            try context.save()
            return post
        } catch {
            return nil
        }
    }
}
