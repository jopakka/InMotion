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
    @IBOutlet weak var changeScreenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets color to specific word in button text
        let mainString = "Already have an account? Register here"
        let stringToColor = "Register here"
        let range = (mainString as NSString).range(of: stringToColor)
        
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: range)
        changeScreenBtn.setAttributedTitle(mutableAttributedString, for: [])
        
        // Setting background image
        assignbackground()
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
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("wrong_username_or_password", comment: ""), presenter: self)
            return
        }
        
        // Check if password is correct
        if user.password != p {
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("wrong_username_or_password", comment: ""), presenter: self)
            return
        }
        
        // Try to save username to defaults
        let prefs = UserDefaults.standard
        prefs.setValue(u, forKey: "user")
        let saved = prefs.synchronize()
        if !saved {
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("there_was_error", comment: ""), presenter: self)
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
