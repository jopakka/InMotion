//
//  AlertHelper.swift
//  InMotion
//
//  Created by iosdev on 28.4.2021.
//

import Foundation
import UIKit

class AlertHelper {
    static let instance = AlertHelper()
    
    // Show alert popup
    func showSimpleAlert(title: String, message: String, presenter: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        presenter.present(alert, animated: true)
    }
}
