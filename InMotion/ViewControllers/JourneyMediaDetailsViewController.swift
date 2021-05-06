//
//  JourneyMediaDetailsViewController.swift
//  InMotion
//
//  Created by Michael Carter on 17.4.2021.
//

import UIKit
import CoreData

// VC for controlling details on post data
class JourneyMediaDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MediaDetailsCellDelegate, NSFetchedResultsControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var receivedPost:Post!
    private var fetchedResultController: NSFetchedResultsController<Post>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // cell registration
        tableView.register(MediaDetailsTableViewCell.nib(), forCellReuseIdentifier: MediaDetailsTableViewCell.identifier)
        
        self.title = NSLocalizedString("Post Details", comment: "Post Details")
        
    }
    
    func deleteBtn(post: Post) {
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            // when ok is pressed navigation controller pops to root and deletes post
            self.navigationController?.popToRootViewController(animated: false)
            CoreHelper.instance.deletePost(post: post)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        AlertHelper.instance.showDeletePostConfirmationAlert(title: "Comfirm Delete?", message: "Are you sure you want to delete this Post? It will be permanent!", presenter: self, actions: [okAction, cancelAction])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // configures cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailsTableViewCell.identifier, for: indexPath) as! MediaDetailsTableViewCell
        cell.delegate = self
        cell.configure(post: receivedPost)
        return cell
    }
    
    // when device rotates, tableview will reload
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        tableView.reloadData()
    }
}
