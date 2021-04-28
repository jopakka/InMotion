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
        let carbonNib = UINib(nibName: "CarbonDetailsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "JourneyOverviewCell")
        tableView.register(carbonNib, forCellReuseIdentifier: "CarbonDetailsTableViewCell")
        
        self.title = date
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return items.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarbonDetailsTableViewCell", for: indexPath) as! CarbonDetailsTableViewCell
            cell.carbonAnswer1.text = "It is answer number 1"
            cell.carbonAnswer2.text = "It is answer number 2"
            cell.carbonAnswer3.text = "It is answer number 3"
            cell.carbonAnswer4.text = "It is answer number 4"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyOverviewCell", for: indexPath) as! JourneyOverviewCell
            cell.name.text = items[indexPath.row]
            cell.photoView.clipsToBounds = true
            cell.photoView.layer.masksToBounds = true
            cell.photoView.contentMode = .scaleAspectFill
            cell.photoView.image = UIImage(named: "loginBackground")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView 
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
