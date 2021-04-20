//
//  User+CoreDataClass.swift
//  InMotion
//
//  Created by iosdev on 15.4.2021.
//
//

import Foundation
import CoreData


public class User: NSManagedObject {
    class func createIfNotExist(username: String, context: NSManagedObjectContext) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username = %ld", username)
        do {
            let matchingMember = try context.fetch(request)
            if (matchingMember.count == 0) {
                let newMember = User(context: context)
                return newMember
            } else {
                print("Database dublicate with username: \(username)")
                return matchingMember[0]
            }
        } catch {
            throw error
        }
    }
}
