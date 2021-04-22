//
//  ProfileViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 22.4.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = getUser()
        updateBanner()
    }
    
    private func updateBanner() {
        fullNameLabel.text = "\(user?.username ?? "")"
        
    }
    
    private func getUser() -> User? {
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
