//
//  RegisterViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 15.4.2021.
//

import UIKit

// View controller for register view
class LoginViewController: UIViewController {
    
    // Text Fields
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    // Buttons
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Trims text fields and if every text field have some text
    // enables login button
    @IBAction func textFieldOnChage(_ sender: UITextField) {
        // Check if text fields have text
        guard var u = usernameTf.text,
           var p = passwordTf.text else {
            return
        }
        
        // Trims text fields
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Enables login button if text fields have enought text
        if(u.count >= 3 && p.count >= 6) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    // Action for login button
    @IBAction func loginAction(_ sender: UIButton) {
        guard var u = usernameTf.text,
           var p = passwordTf.text else {
            return
        }
        
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let managedContext = AppDelegate.viewContext
        guard let user = try? User.checkIfUserExist(username: u, context: managedContext) else {
            NSLog("User with username \"%@\" not exists", u)
            return
        }
        
        if user.password != p {
            NSLog("Wrong password")
            return
        }
        
        let prefs = UserDefaults.standard
        prefs.setValue(u, forKey: "user")
        let saved = prefs.synchronize()
        if !saved {
            NSLog("Failed to save user in defaults")
            return
        }
        // TODO: navigate to next view
    }
}
