//
//  ProfileViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 22.4.2021.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
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
    
    @IBOutlet weak var profileContainer: CircularCard!
    
    private var user: User!
    private var imagePicker = UIImagePickerController()
    private var currentImagePickerButton: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set profile image settings
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        profileContainer.cornerRadius = profileImageView.frame.size.width / 2
        // set navbar gradient
        let image = self.navigationController!.getGradient()
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
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
            logout()
            return
        }
        updateInfos()
    }
    
    // https://developer.apple.com/forums/thread/110223?answerId=337254022#337254022
    @objc func touch() {
        self.view.endEditing(true)
    }
    
    // First name and last name text fields on change edit function
    @IBAction func nameEdited(_ sender: UITextField) {
        setSaveNameButtonStatus()
    }
    
    // Password fields on change edit function
    @IBAction func passwordEdited(_ sender: UITextField) {
        if user.password == oldPasswordTf.text && newPasswordTf.text?.count ?? 0 >= 6 && confirmPasswordTf.text == newPasswordTf.text {
            savePasswordButton.isEnabled = true
        } else {
            savePasswordButton.isEnabled = false
        }
    }
    
    // Checks status for save name button
    private func setSaveNameButtonStatus() {
        if user.firstname == firstnameTf.text, user.lastname == lastnameTf.text {
            saveNameButton.isEnabled = false
        } else {
            saveNameButton.isEnabled = true
        }
    }
    
    // Updates displayed values
    private func updateInfos() {
        fullNameLabel.text = "\(user.firstname ?? "") \(user.lastname ?? "")"
        
        firstnameTf.text = "\(user.firstname ?? "")"
        lastnameTf.text = "\(user.lastname ?? "")"
        
        var profileImage = UIImage(systemName: "person.fill")
        if user.avatarImg != nil {
            profileImage = UIImage(data: user.avatarImg!)!
        }
        profileImageView.image = profileImage
        
        var bannerImage = UIImage(named: "loginBackground")
        if user.bannerImg != nil {
            bannerImage = UIImage(data: user.bannerImg!)!
        }
        bannerImageView.image = bannerImage
    }
    
    // Action for save name button
    @IBAction func updateName(_ sender: UIButton) {
        // Check that text fields are valid
        guard var fname = firstnameTf.text, var lname = lastnameTf.text else {
            return
        }
        
        // Trim names
        fname = fname.trimmingCharacters(in: .whitespacesAndNewlines)
        lname = lname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        saveData(value: fname, type: .fname)
        saveData(value: lname, type: .lname)
    }
    
    // Logout button action
    @IBAction func logoutAction(_ sender: UIButton) {
        
        logout()
    }
    
    // Save users new data to core
    private func saveData(value: Any, type: UserDataTypes) {
        CoreHelper.instance.saveUserData(user: user, value: value, type: type)
        
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
    }
    
    private func logout() {
        // Clear username from defaults
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "user")
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let vc = board.instantiateViewController(identifier: "Login") as! LoginViewController
        let win = UIApplication.shared.windows.first
        win?.rootViewController = vc
        win?.makeKeyAndVisible()
        navigationController?.popToRootViewController(animated: true)
        
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Select image from gallery
    // https://stackoverflow.com/a/25514262
    @IBAction func selectImageFromGallery(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            currentImagePickerButton = sender.tag
            
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
            return
        }
        
        guard let imgData = pickedImage.jpegData(compressionQuality: 80) else {
            return
        }
        
        switch currentImagePickerButton {
        case 0:
            saveData(value: imgData, type: .avatar)
            break
        case 1:
            saveData(value: imgData, type: .banner)
            break
        default:
            break
        }
        
        picker.dismiss(animated: true, completion: nil)
        currentImagePickerButton = nil
        updateInfos()
    }
}

extension ProfileViewController: UITextFieldDelegate {
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
