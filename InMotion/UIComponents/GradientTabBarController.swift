//
//  GradientTabBarController.swift
//  InMotion
//
//  Created by iosdev on 4.5.2021.
//

import UIKit

class GradientTabBarController: UITabBarController {

    let gradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        gradient.type = .axial
        gradient.colors = [
            UIColor.link.cgColor,
            UIColor.blue.cgColor
        ]
        gradient.locations = [0, 0.7, 1]
        gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
