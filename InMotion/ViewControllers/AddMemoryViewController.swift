//
//  AddMemoryViewController.swift
//  InMotion
//
//  Created by iosdev on 22.4.2021.
//

import Foundation
import UIKit
import CoreData

class AddMemoryViewController: UIViewController{

    @IBOutlet weak var addTitleTextView: UITextField!
    @IBOutlet weak var memoryPhoto: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    
    private var imagePicker = UIImagePickerController()
    private var selectedImageData: Data?
    var journey: Journey!
    var location: CLLocation!
    
    private let notePlaceholder = "Here you can enter memory text"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNewBackButton()
        setSaveButton()
        
        notesTextView.delegate = self
        notesTextView.text = notePlaceholder
        notesTextView.textColor = .lightGray
    }
    
    private func setSaveButton() {
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save(sender:)))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func save(sender: UIBarButtonItem) {
        print("save work")
        
        guard let location = location else {
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "No location", presenter: self)
            return
        }
        
        guard let (title, blog) = getTrimmedTexts() else {
            return
        }
        
        if title.count == 0 {
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "Title can't be empty", presenter: self)
            return
        }
        
        guard let imgData = selectedImageData else {
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "Missing image", presenter: self)
            return
        }
        
        let managedContext = AppDelegate.viewContext
        let post = Post.createNewPost(title: title, blog: blog, imgData: imgData, location: location, journey: journey, context: managedContext)
        
        if post != nil {
            AlertHelper.instance.showSimpleAlert(title: "Success", message: "Memory saved", presenter: self, actions: [UIAlertAction(title: "OK", style: .default, handler: ({ _ in
                self.clearAll()
                self.navigationController?.popViewController(animated: true)
            }))])
        } else {
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "Error while saving memory", presenter: self)
        }
    }
    
    private func setNewBackButton() {
        // https://stackoverflow.com/a/27713813
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // https://stackoverflow.com/a/27713813
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("back works !!!!")
        
        let alert = UIAlertController(title: "Warning!", message: "Your memory will not be saved. Do you wanna continue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("YES", comment: "Default action"), style: .default) { _ in
            self.clearAll()
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("NO", comment: "Default action"), style: .default))
        self.present(alert, animated: true)
    }
    
    private func clearAll() {
        addTitleTextView.text = ""
        notesTextView.text = ""
        memoryPhoto.image = nil
    }
    
    func getTrimmedTexts() -> (String, String)? {
        // Check if text fields have text
        guard var t = addTitleTextView.text, var b = notesTextView.text else {
            return nil
        }
        
        // Trim text fields
        t = t.trimmingCharacters(in: .whitespacesAndNewlines)
        b = b.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (t, b)
    }
}

extension AddMemoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
    
    
    @IBAction func takeImageAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            NSLog("Taking image")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true)
        } else {
            AlertHelper.instance.showSimpleAlert(title: "Error", message: "This is not working on simulator", presenter: self)
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
        
        selectedImageData = imgData
        memoryPhoto.image = UIImage(data: imgData)
        
        picker.dismiss(animated: true, completion: nil)
    }
}

// https://stackoverflow.com/a/10201671
extension AddMemoryViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == notePlaceholder && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = notePlaceholder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
}
    
