//
//  RegisterViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 15.4.2021.
//

import UIKit

// View controller for register view
class RegisterViewController: UIViewController {
    
    // Text Fields
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var confirmPasswordTf: UITextField!
    
    // Buttons
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func textFieldOnChage(_ sender: UITextField) {
        guard var u = usernameTf.text,
           var e = emailTf.text,
           var p = passwordTf.text,
           var cp = confirmPasswordTf.text else {
            return
        }
        
        u = trimString(u)
        e = trimString(e)
        p = trimString(p)
        cp = trimString(cp)
        
        if(u.count > 0 && e.count > 0 && p.count > 0 && cp.count > 0) {
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
        }
    }
    
    // Action to take user to login page
    @IBAction func toLoginPageAction(_ sender: UIButton) {
    }
    
    // Action to registering new user
    @IBAction func registerAction(_ sender: UIButton) {
    }
    
    private func trimString(_ text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
