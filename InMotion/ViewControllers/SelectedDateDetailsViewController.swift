//
//  SelectedDateDetailsViewController.swift
//  InMotion
//
//  Created by iosdev on 17.4.2021.
//

import UIKit

class SelectedDateDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = ["item1", "item2", "item3"]
    var rowSelected: Int?
    var date: String?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "JourneyOverviewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "JourneyOverviewCell")
        self.title = date
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyOverviewCell", for: indexPath) as! JourneyOverviewCell
        cell.name.text = items[indexPath.row]
        cell.photoView.clipsToBounds = true
        cell.photoView.layer.masksToBounds = true
        cell.photoView.contentMode = .scaleAspectFill
        cell.photoView.image = UIImage(named: "loginBackground")
        return cell
    }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! JourneyDetailsViewController
        destVC.index = tableView.indexPathForSelectedRow!.row
        self.tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)

        }


}
