//
//  JourneySaveViewController.swift
//  InMotion
//
//  Created by iosdev on 22.4.2021.
//

import Foundation
import UIKit
import MOPRIMTmdSdk

class JourneySaveViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNewBackButton()
        
        MoprimApi.instance.fetchData(date: Date())
    }
    
    private func setNewBackButton() {
        // https://stackoverflow.com/a/27713813
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // https://stackoverflow.com/a/27713813
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("back works !!!!")
        navigationController?.popViewController(animated: false)
    }
}
