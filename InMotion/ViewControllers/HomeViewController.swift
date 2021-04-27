//
//  HomeViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 26.4.2021.
//

import UIKit
import MOPRIMTmdSdk

class HomeViewController: UIViewController {
    
    // Text fields
    @IBOutlet weak var fullnameTf: UILabel!
    
    private var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        user = UserHelper.instance.user
        if user == nil {
            // TODO: This should log user out
            NSLog("No user. Logging out")
            return
        }
        
        TMDCloudApi.fetchStats(forLast: 30).continueWith { (task) -> Any? in
            DispatchQueue.main.async {
                if let error = task.error {
                    NSLog("fetchData Error: %@", error.localizedDescription)
                }
                else if let data = task.result {
                    NSLog("fetchData result: %@", data)
                    var dict = [String: Double]()
                    for d in data.allStats() {
                        if dict[d.activity] != nil {
                            dict[d.activity]! += d.userDistance
                        } else {
                            dict[d.activity] = d.userDistance
                        }
                    }
                    print(dict)
                }
                return
            }
        }
        
        updateInfos()
    }
    
    private func updateInfos() {
        fullnameTf.text = "\(user.firstname ?? "") \(user.lastname ?? "")"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
