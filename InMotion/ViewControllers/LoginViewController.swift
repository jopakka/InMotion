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
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    // Buttons
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func textFieldOnChage(_ sender: UITextField) {
        guard var e = emailTf.text,
           var p = passwordTf.text else {
            return
        }
        
        e = e.trimmingCharacters(in: .whitespacesAndNewlines)
        p = p.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(e.count > 0 && p.count > 0) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
}
