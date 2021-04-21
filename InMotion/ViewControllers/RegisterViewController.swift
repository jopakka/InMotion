//
//  RegisterViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 15.4.2021.
//

import UIKit
import CoreData

// View controller for register view
class RegisterViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // Text Fields
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmPasswordTf: UITextField!
    
    // Buttons
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Trims text fields and if every text field have some text
    // enables register button
    @IBAction func textFieldOnChage(_ sender: UITextField) {
        // Check if text fields have text
        guard var u = usernameTf.text,
           var p = passwordTf.text,
           var cp = confirmPasswordTf.text else {
            return
        }
        
        // Trim text fields
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        cp = cp.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Enables register button if text fields have enought text
        if(u.count > 0 && p.count > 0 && cp.count > 0) {
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
        }
    }
    
    // Pop current view to navigate back login view
    @IBAction func haveActionAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // Action to registering new user
    @IBAction func registerAction(_ sender: UIButton) {
        // Check if text fields have text
        guard var u = usernameTf.text,
           var p = passwordTf.text,
           var cp = confirmPasswordTf.text else {
            return
        }
        
        // Trim text fields
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        cp = cp.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check text fields for errors
        // TODO: Do something nice with errors
        var errors = false
        if u.count < 3 { errors = true }
        if p.count < 6 { errors = true }
        if p != cp { errors = true }
        if errors { return }
        
        // Checks if username already exists
        let managedContext = AppDelegate.viewContext
        guard let user = try? User.createIfNotExist(username: u, context: managedContext) else {
            NSLog("Username already exists")
            return
        }
        
        user.username = u
        user.password = p
        
        // Try to save new user to Core Data.
        // If succeed set username to defaults
        // so we know user is logged in
        do {
            try managedContext.save()
            let prefs = UserDefaults.standard
            prefs.setValue(u, forKey: "user")
            let saved = prefs.synchronize()
            if !saved {
                NSLog("Failed to save user in defaults")
                return
            }
            NSLog("User saved to defaults")
            // TODO: navigate to next view
        } catch {
            NSLog("Creating user failed")
        }
    }
}
