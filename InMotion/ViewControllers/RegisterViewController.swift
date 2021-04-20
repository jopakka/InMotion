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
    
    @IBAction func textFieldOnChage(_ sender: UITextField) {
        guard var u = usernameTf.text,
           var p = passwordTf.text,
           var cp = confirmPasswordTf.text else {
            return
        }
        
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        cp = cp.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
        guard var u = usernameTf.text,
           var p = passwordTf.text,
           var cp = confirmPasswordTf.text else {
            return
        }
        
        u = u.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        cp = cp.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var errors = false
        if u.count < 3 { errors = true }
        if p.count < 6 { errors = true }
        if p != cp { errors = true }
        if errors { return }
        
        let managedContext = AppDelegate.viewContext
        guard let user = try? User.createIfNotExist(username: u, context: managedContext) else {
            return
        }
        
        user.username = u
        user.password = p
        do {
            try managedContext.save()
        } catch {
            print("Save failed")
        }
    }
}
