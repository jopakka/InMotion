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
    
    private let notePlaceholder = NSLocalizedString("note_placeholder", comment: "")
    private let errorTitle = NSLocalizedString("error", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNewBackButton()
        setSaveButton()
        
        notesTextView.delegate = self
        notesTextView.text = notePlaceholder
        notesTextView.textColor = .lightGray
    }
    
    private func setSaveButton() {
        let saveButton = UIBarButtonItem(title: NSLocalizedString("save", comment: ""), style: .plain, target: self, action: #selector(save(sender:)))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func save(sender: UIBarButtonItem) {
        print("save work")
        
        guard let location = location else {
            AlertHelper.instance.showSimpleAlert(title: errorTitle, message: NSLocalizedString("no_location", comment: ""), presenter: self)
            return
        }
        
        guard let (title, blog) = getTrimmedTexts() else {
            return
        }
        
        if title.count == 0 {
            AlertHelper.instance.showSimpleAlert(title: errorTitle, message: NSLocalizedString("no_title", comment: ""), presenter: self)
            return
        }
        
        guard let imgData = selectedImageData else {
            AlertHelper.instance.showSimpleAlert(title: errorTitle, message: NSLocalizedString("no_image", comment: ""), presenter: self)
            return
        }
        
        let managedContext = AppDelegate.viewContext
        let post = Post.createNewPost(title: title, blog: blog, imgData: imgData, location: location, journey: journey, context: managedContext)
        
        if post != nil {
            AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("memory_saved", comment: ""), presenter: self, actions: [UIAlertAction(title: "OK", style: .default, handler: ({ _ in
                self.clearAll()
                self.navigationController?.popViewController(animated: true)
            }))])
        } else {
            AlertHelper.instance.showSimpleAlert(title: errorTitle, message: NSLocalizedString("error_saving_memory", comment: ""), presenter: self)
        }
    }
    
    private func setNewBackButton() {
        // https://stackoverflow.com/a/27713813
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: NSLocalizedString("cancel", comment: ""), style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // https://stackoverflow.com/a/27713813
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("back works !!!!")
        
        let alert = UIAlertController(title: NSLocalizedString("warning", comment: ""), message: NSLocalizedString("memory_will_not_be_saved", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) { _ in
            self.clearAll()
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: NSLocalizedString("no", comment: ""), style: .default))
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
        AlertHelper.instance.showSimpleAlert(title: NSLocalizedString("not_working", comment: ""), message: "", presenter: self)
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            NSLog("Taking image")
//
//            imagePicker.delegate = self
//            imagePicker.sourceType = .camera
//            imagePicker.allowsEditing = true
//
//            present(imagePicker, animated: true)
//        } else {
//            AlertHelper.instance.showSimpleAlert(title: errorTitle, message: NSLocalizedString("not_work_in_sim", comment: ""), presenter: self)
//        }
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
    
