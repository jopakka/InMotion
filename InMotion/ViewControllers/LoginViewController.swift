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
        
        // Check if user is logged in
        if getLoggedUser() != nil {
            // Navigate to next screen
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
        
        self.usernameTf.delegate = self
        self.passwordTf.delegate = self
        
    }
    
    private func getLoggedUser() -> String? {
        let prefs = UserDefaults.standard
        let user = prefs.string(forKey: "user")
        return  user
    }
    
    // Trims text fields and if every text field have some text
    // enables login button
    @IBAction func textFieldOnChage(_ sender: UITextField) {
        guard let (u, p) = getTrimmedTexts() else {
            return
        }
        
        // Enables login button if text fields have enought text
        if(u.count >= 3 && p.count >= 6) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
    // Action for login button
    @IBAction func loginAction(_ sender: UIButton) {
        guard let (u, p) = getTrimmedTexts() else {
            return
        }
        
        let managedContext = AppDelegate.viewContext
        
        // Check if username exists
        guard let user = try? User.checkIfUserExist(username: u, context: managedContext) else {
            NSLog("User with username \"%@\" not exists", u)
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "Wrong username or password", presenter: self)
            return
        }
        
        // Check if password is correct
        if user.password != p {
            NSLog("Wrong password")
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "Wrong username or password", presenter: self)
            return
        }
        
        // Try to save username to defaults
        let prefs = UserDefaults.standard
        prefs.setValue(u, forKey: "user")
        let saved = prefs.synchronize()
        if !saved {
            NSLog("Failed to save user in defaults")
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "There was some error", presenter: self)
            return
        }
        
        // Navigate to next screen
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    func getTrimmedTexts() -> (String, String)? {
        // Check if text fields have text
        guard var u = usernameTf.text,
              var p = passwordTf.text else {
            return nil
        }
        
        // Trim text fields
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (u, p)
    }
}

extension LoginViewController : UITextFieldDelegate {
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard when presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTf.resignFirstResponder()
        passwordTf.resignFirstResponder()
        return(true)
    }
}
