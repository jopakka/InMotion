//
//  MainTabViewController.swift
//  InMotion
//
//  Created by iosdev on 21.4.2021.
//

import UIKit

class MainTabViewController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Testing fetch
        
        print("FETCH METADATA")
        MoprimApi.instance.fetchMetadata()
        
        print("FETCH DATA")
        var i = 0
        while i < 100 {
            MoprimApi.instance.fetchData(date: Date().advanced(by: TimeInterval(-86400*i)))
            i += 1
        }
    }
    
}
