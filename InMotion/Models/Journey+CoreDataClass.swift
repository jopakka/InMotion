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

    // Creates new journey with id, start time and user added
    class func createNewJourney(user: User, context: NSManagedObjectContext) -> Journey?  {
        let uuid = UUID()
        let journey = Journey(context: context)
        journey.journeyId = uuid
        journey.journeyStarted = Date()
        user.addToJourney(journey)
        try? context.save()
        return journey
    }
    
    // Returns journey with given UUID
    class func fetchJourneyWithUUID(uuid: UUID, context: NSManagedObjectContext) throws -> Journey? {
        let request: NSFetchRequest<Journey> = Journey.fetchRequest()
        request.predicate = NSPredicate(format: "journeyId == %@", uuid as CVarArg)
        do {
            let matchingJourneys = try context.fetch(request)
            return matchingJourneys.first
        } catch {
            throw error
        }
    }
    
    // Returns all journeys of given user
    class func fetchJourneysForUser(user: User, context: NSManagedObjectContext) throws -> [Journey] {
        let request: NSFetchRequest<Journey> = Journey.fetchRequest()
        request.predicate = NSPredicate(format: "user == %@", user)
        let sorter = NSSortDescriptor(key: "journeyStarted", ascending: true)
        request.sortDescriptors = [sorter]
        do {
            let matchingJourneys = try context.fetch(request)
            for j in matchingJourneys {
                print(j.journeyId!)
            }
            return matchingJourneys
        } catch {
            throw error
        }
    }
}
