//
//  ProfileViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 22.4.2021.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    private var user: User!
    private var imagePicker = UIImagePickerController()
    private var selectedImage: UIImage?
    
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
        
        user = UserHelper.instance.user
        guard user != nil else {
            // User not found
            // TODO: Logout
            NSLog("This should logout")
            return
        }
        updateInfos()
    }
    
    // https://developer.apple.com/forums/thread/110223?answerId=337254022#337254022
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    // Select image from gallery
    // https://stackoverflow.com/a/25514262
    @IBAction func selectImageFromGallery(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            NSLog("Selecting image from album")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true)
        }
    }
    
    // MARK:-- ImagePicker delegate
    // https://stackoverflow.com/a/52263803
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else {
            NSLog("No picked image")
            return
        }
        
        guard let imgData = pickedImage.jpegData(compressionQuality: 80) else {
            NSLog("No image data")
            return
        }
        
        profileImageView.image = UIImage(data: imgData)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameEdited(_ sender: UITextField) {
        setSaveNameButtonStatus()
    }
    
    @IBAction func passwordEdited(_ sender: UITextField) {
        if user.password == oldPasswordTf.text && newPasswordTf.text?.count ?? 0 >= 6 && confirmPasswordTf.text == newPasswordTf.text {
            savePasswordButton.isEnabled = true
        } else {
            savePasswordButton.isEnabled = false
        }
    }
    
    private func setSaveNameButtonStatus() {
        if user.firstname == firstnameTf.text, user.lastname == lastnameTf.text {
            saveNameButton.isEnabled = false
        } else {
            saveNameButton.isEnabled = true
        }
    }
    
    private func updateInfos() {
        fullNameLabel.text = "\(user.firstname ?? "") \(user.lastname ?? "")"
        
        firstnameTf.text = "\(user.firstname ?? "")"
        lastnameTf.text = "\(user.lastname ?? "")"
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
            if type == .password {
                oldPasswordTf.text = ""
                newPasswordTf.text = ""
                confirmPasswordTf.text = ""
                savePasswordButton.isEnabled = false
            } else {
                updateInfos()
                setSaveNameButtonStatus()
            }
            
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
