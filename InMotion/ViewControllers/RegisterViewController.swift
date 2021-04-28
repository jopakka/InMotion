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
        self.usernameTf.delegate = self
        self.passwordTf.delegate = self
        self.confirmPasswordTf.delegate = self
    }
    
    // Trims text fields and if every text field have some text
    // enables register button
    @IBAction func textFieldOnChage(_ sender: UITextField) {
        guard let (u, p, cp) = getTrimmedTexts() else {
            return
        }
        
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
        guard let (u, p, cp) = getTrimmedTexts() else {
            return
        }
        
        // Check text fields for errors
        var errors = ""
        if u.count < 3 { errors += "Username must be atleast 3 characters long.\n" }
        if p.count < 6 { errors += "Password must be atleast 6 characters long.\n" }
        if p != cp { errors += "Passwords doesn't match" }
        if errors.count > 0 {
            AlertHelper.instance.showSimpleAlert(title: "Errors while creating user", message: errors, presenter: self)
            return
        }
        
        // Checks if username already exists
        let managedContext = AppDelegate.viewContext
        guard let user = try? User.createIfNotExist(username: u, context: managedContext) else {
            NSLog("Username already exists")
            AlertHelper.instance.showSimpleAlert(title: "Username already exists", message: "Username already exists", presenter: self)
            return
        }
        
        user.username = u
        user.password = p
        
        // Try to save new user to Core Data.
        // If succeed set username to defaults
        // so we know that user is logged in
        do {
            try managedContext.save()
            let prefs = UserDefaults.standard
            prefs.setValue(u, forKey: "user")
            let saved = prefs.synchronize()
            if !saved {
                NSLog("Failed to save user in defaults")
                throw UserCreationErrors.creationFailed
            }
            NSLog("User saved to defaults")
            
            // Navigate to next screen
            self.performSegue(withIdentifier: "registerSegue", sender: self)
        } catch {
            NSLog("Creating user failed")
            AlertHelper.instance.showSimpleAlert(title: "Creating user failed", message: "There was some errors while creating user. Please try again.", presenter: self)
        }
    }
    
    func getTrimmedTexts() -> (String, String, String)? {
        // Check if text fields have text
        guard var u = usernameTf.text,
              var p = passwordTf.text,
              var cp = confirmPasswordTf.text else {
            return nil
        }
        
        // Trim text fields
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        cp = cp.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (u, p, cp)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTf.resignFirstResponder()
        passwordTf.resignFirstResponder()
        confirmPasswordTf.resignFirstResponder()
        return(true)
    }
}

enum UserCreationErrors: Error {
    case creationFailed
}
