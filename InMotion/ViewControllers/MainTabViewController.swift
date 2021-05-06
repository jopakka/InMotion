//
//  MainTabViewController.swift
//  InMotion
//
//  Created by iosdev on 21.4.2021.
//

import UIKit

// Controller for tab bars - sets the gradient background to the tab bar.
class MainTabViewController : UITabBarController {
    let layerGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = self.getGradient()
        UITabBar.appearance().backgroundImage = image
    }
    
    func getGradient() -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width,height: tabBar.bounds.height + 40)
        gradientLayer.colors = [UIColor.link.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // vertical gradient start
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // vertical gradient end
        
        // creates a UIImage from graphics
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
}
