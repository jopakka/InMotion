//
//  ProfileViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 22.4.2021.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    // Scroll view
    @IBOutlet weak var scrollview: UIScrollView!
    
    // Labels
    @IBOutlet weak var fullNameLabel: UILabel!
    
    // Image views
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // Text fields
    @IBOutlet weak var firstnameTf: UITextField!
    @IBOutlet weak var lastnameTf: UITextField!
    @IBOutlet weak var oldPasswordTf: UITextField!
    @IBOutlet weak var newPasswordTf: UITextField!
    @IBOutlet weak var confirmPasswordTf: UITextField!
    
    // Buttons
    @IBOutlet weak var saveNameButton: UIButton!
    @IBOutlet weak var savePasswordButton: UIButton!
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstnameTf.delegate = self
        lastnameTf.delegate = self
        oldPasswordTf.delegate = self
        newPasswordTf.delegate = self
        confirmPasswordTf.delegate = self
        
        // https://developer.apple.com/forums/thread/110223?answerId=337254022#337254022
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollview.addGestureRecognizer(recognizer)
        
        user = getUser()
        guard user != nil else {
            // User not found
            // TODO: Logout
            return
        }
        updateInfos()
    }
    
    // https://developer.apple.com/forums/thread/110223?answerId=337254022#337254022
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    @IBAction func nameEdited(_ sender: UITextField) {
        setSaveNameButtonStatus()
    }
    
    private func setSaveNameButtonStatus() {
        if user?.firstname == firstnameTf.text, user?.lastname == lastnameTf.text {
            saveNameButton.isEnabled = false
        } else {
            saveNameButton.isEnabled = true
        }
    }
    
    private func updateInfos() {
        fullNameLabel.text = "\(user?.firstname ?? "") \(user?.lastname ?? "")"
        
        firstnameTf.text = "\(user?.firstname ?? "")"
        lastnameTf.text = "\(user?.lastname ?? "")"
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
    
    @IBAction func updateName(_ sender: UIButton) {
        NSLog("Update name")
        // Check that text fields are valid
        guard var fname = firstnameTf.text, var lname = lastnameTf.text else {
            NSLog("No firstname text or lastname text")
            return
        }
        
        // Trim names
        fname = fname.trimmingCharacters(in: .whitespacesAndNewlines)
        lname = lname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let username = user?.username ?? ""
        saveData(username: username, value: fname, type: .fname)
        saveData(username: username, value: lname, type: .lname)
    }
    
    // Logout button action
    @IBAction func logoutAction(_ sender: UIButton) {
        NSLog("Logout begin")
        
        // Clear username from defaults
//        let prefs = UserDefaults.standard
//        prefs.removeObject(forKey: "user")
        
        // Navigate to login page
//        navigationController?.popToRootViewController(animated: true)
        
        showSimpleAlert(title: "Not working", message: "This function is not working")
    }
    
    // Save users new data to core
    private func saveData(username: String, value: String, type: UserData) {
        let managedContext = AppDelegate.viewContext
        guard let user = try? User.checkIfUserExist(username: username, context: managedContext) else {
            // No user found for some reason
            return
        }
        
        switch type {
        case .fname:
            user.firstname = value
        case .lname:
            user.lastname = value
        case .password:
            user.password = value
        }
        
        do {
            try managedContext.save()
            updateInfos()
            setSaveNameButtonStatus()
            view.endEditing(true)
        } catch {
            NSLog("Failed to save user to core")
        }
    }
    
    // Show alert popup
    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true)
    }
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("View pressed")
        self.view.endEditing(true)
    }
    
    // Hide keyboard when presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstnameTf.resignFirstResponder()
        lastnameTf.resignFirstResponder()
        oldPasswordTf.resignFirstResponder()
        newPasswordTf.resignFirstResponder()
        confirmPasswordTf.resignFirstResponder()
        return true
    }
}

private enum UserData {
    case fname
    case lname
    case password
}
