//
//  CoreHelper.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import Foundation
import CoreData

// Has some nice core data functions
class CoreHelper {
    static let instance = CoreHelper()
    private let managedContext = AppDelegate.viewContext
    
    // Saves users data to core
    func saveUserData(user: User, value: Any, type: UserDataTypes) {
        switch type {
        case .fname:
            user.firstname = value as? String
            break
        case .lname:
            user.lastname = value as? String
            break
        case .password:
            user.password = value as? String
            break
        case .avatar:
            user.avatarImg = value as? Data
            break
        case .banner:
            user.bannerImg = value as? Data
            break
        default:
            NSLog("Nothing is saved to user")
            return
        }
        
        do {
            try managedContext.save()
        } catch {
            NSLog("saveUserData error: %@", error.localizedDescription)
        }
    }
}

enum UserDataTypes {
    case avatar
    case banner
    case fname
    case lname
    case password
    case username
}
