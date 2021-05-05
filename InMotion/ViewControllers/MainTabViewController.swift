//
//  MainTabViewController.swift
//  InMotion
//
//  Created by iosdev on 21.4.2021.
//

import UIKit

class MainTabViewController : UITabBarController {
    let layerGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layerGradient.colors = [UIColor.link.cgColor, UIColor.blue.cgColor]
        layerGradient.startPoint = CGPoint(x: 0.5, y: 0)
        layerGradient.endPoint = CGPoint(x: 0.5, y: 1)
       
        layerGradient.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width,height: tabBar.bounds.height + 40)
        self.tabBar.layer.insertSublayer(layerGradient, at: 0)
        
        // Test to see data directly from Moprim
        //var i = 0
        //while i < 100 {
        //    MoprimApi.instance.printData(date: Date().advanced(by: TimeInterval(-86400*i)))
        //   i += 1
        // }
    }
    
}
