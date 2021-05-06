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
    @IBOutlet weak var changeScreenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTf.delegate = self
        self.passwordTf.delegate = self
        self.confirmPasswordTf.delegate = self
        
        // assigning background
        assignbackground()
        
        // sets color to specific word in button text
        let mainString = "Already have an account? Login here"
        let stringToColor = "Login here"
        let range = (mainString as NSString).range(of: stringToColor)
        
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: range)
        changeScreenBtn.setAttributedTitle(mutableAttributedString, for: [])
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
        if u.count < 3 { errors += NSLocalizedString("username_length_error", comment: "") + "\n" }
        if p.count < 6 { errors += NSLocalizedString("password_length_error", comment: "") + "\n" }
        if p != cp { errors += NSLocalizedString("passwords_not_match", comment: "") }
        if errors.count > 0 {
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("user_creating_error_title", comment: ""), message: errors, presenter: self)
            return
        }
        
        // Checks if username already exists
        let managedContext = AppDelegate.viewContext
        guard let user = try? User.createIfNotExist(username: u, context: managedContext) else {
//            NSLog("Username already exists")
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("username_exists", comment: ""), message: NSLocalizedString("username_exists", comment: ""), presenter: self)
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
//                NSLog("Failed to save user in defaults")
                throw UserCreationErrors.creationFailed
            }
//            NSLog("User saved to defaults")
            
            // Navigate to next screen
            self.performSegue(withIdentifier: "registerSegue", sender: self)
        } catch {
//            NSLog("Creating user failed")
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("user_creating_error_title", comment: ""), message: NSLocalizedString("user_creating_error_title", comment: ""), presenter: self)
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
    
    // Setting background image
    func assignbackground(){
        let background = UIImage(named: "loginBackground")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
      }
    
}

enum UserCreationErrors: Error {
    case creationFailed
}
