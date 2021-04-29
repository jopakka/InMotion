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
        
 
        tableView.register(JourneyOverviewCell.nib(), forCellReuseIdentifier: JourneyOverviewCell.identifier)
        tableView.register(CarbonDetailsTableViewCell.nib(), forCellReuseIdentifier: CarbonDetailsTableViewCell.identifier)
        tableView.register(PieChartTableViewCell.nib(), forCellReuseIdentifier: PieChartTableViewCell.identifier)
        
        self.title = date
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        else {
            return items.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.identifier, for: indexPath) as! PieChartTableViewCell
            cell.configure(with: UIImage(named: "piechartPlaceHolder")!)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarbonDetailsTableViewCell.identifier, for: indexPath) as! CarbonDetailsTableViewCell
            cell.configure(distanceTravelled: "100km", timeTravelled: "10hr", emmissions: "300kg", popularTransport: "Car")
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: JourneyOverviewCell.identifier, for: indexPath) as! JourneyOverviewCell
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
        if indexPath.section == 2{
            performSegue(withIdentifier: "showDetails", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! JourneyDetailsViewController
        destVC.index = tableView.indexPathForSelectedRow!.row
        self.tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        
    }
    
    
}
