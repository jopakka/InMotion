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
    func showSimpleAlert(title: String, message: String, presenter: UIViewController, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions, actions.count > 0 {
            for a in actions {
                alert.addAction(a)
            }
        } else {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        }
        presenter.present(alert, animated: true)
    }
    
    func showDeleteConfirmationAlert(title: String, message: String, presenter: JourneyDetailsViewController, actions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions = actions, actions.count > 0 {
            for a in actions {
                alert.addAction(a)
            }
        } else {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        }
        presenter.present(alert, animated: true)
    }
}
