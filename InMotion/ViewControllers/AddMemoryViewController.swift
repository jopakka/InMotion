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
    
