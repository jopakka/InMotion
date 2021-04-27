//
//  UserHelper.swift
//  InMotion
//
//  Created by iosdev on 26.4.2021.
//

import Foundation

class UserHelper {
    static let instance = UserHelper()
    
    private(set) var user: User?
    
    init() {
        user = getUser()
    }
    
    func getUser() -> User? {
        let managedContext = AppDelegate.viewContext
        let prefs = UserDefaults.standard
        guard let username: String = prefs.string(forKey: "user") else {
            NSLog("No username found")
            return nil
        }
        guard let user = try? User.checkIfUserExist(username: username, context: managedContext) else {
            NSLog("No user found on Core Data")
            return nil
        }
        
        return user
    }
}
