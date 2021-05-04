//
//  JourneyMediaDetailsViewController.swift
//  InMotion
//
//  Created by iosdev on 17.4.2021.
//

import UIKit

class JourneyMediaDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var receivedPost:Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MediaDetailsTableViewCell.nib(), forCellReuseIdentifier: MediaDetailsTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailsTableViewCell.identifier, for: indexPath) as! MediaDetailsTableViewCell
        
        cell.configure(image: UIImage(data: receivedPost.postImg!)!, title: receivedPost.postTitle!, description: receivedPost.postBlog!)
        return cell
    }
    

}
