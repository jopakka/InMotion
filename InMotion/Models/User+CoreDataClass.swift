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
    
    // Creates new user to Core Data if username is not used
    // else it return nill
    class func createIfNotExist(username: String, context: NSManagedObjectContext) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        do {
            let matchingMember = try context.fetch(request)
            if (matchingMember.count == 0) {
                let newMember = User(context: context)
                return newMember
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    // Checks if there is user with given username
    // Returns that user if found else returns nil
    class func checkIfUserExist(username: String, context: NSManagedObjectContext) throws -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)
        do {
            let matchingMember = try context.fetch(request)
            if (matchingMember.count == 1) {
                return matchingMember[0]
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
}
