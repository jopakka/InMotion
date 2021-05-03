//
//  SelectedDateDetailsViewController.swift
//  InMotion
//
//  Created by iosdev on 17.4.2021.
//

import UIKit
import CoreData

class SelectedDateDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var startDate = NSDate()
    var endDate = NSDate()
    
    var dailyDetails: Details?

    var user: User!
    var userJourneys = [Journey]()
    
    var journeySelected: Journey?
    private var fetchedResultController: NSFetchedResultsController<Journey>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        user = UserHelper.instance.user
        if user == nil {
            // TODO: This should log user out
            NSLog("No user. Logging out")
            return
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(JourneyOverviewCell.nib(), forCellReuseIdentifier: JourneyOverviewCell.identifier)
        tableView.register(CarbonDetailsTableViewCell.nib(), forCellReuseIdentifier: CarbonDetailsTableViewCell.identifier)
        tableView.register(PieChartTableViewCell.nib(), forCellReuseIdentifier: PieChartTableViewCell.identifier)
        
        setDateHeader(date: startDate)
        fetchJourneyByDate()
        setDailyInfo()
    }
    
    func fetchJourneyByDate(){
        if fetchedResultController == nil {
            let managedContext = AppDelegate.viewContext
            let fetchRequest: NSFetchRequest<Journey> = Journey.fetchRequest()
            fetchRequest.returnsObjectsAsFaults = false
            let sorter = NSSortDescriptor(key: "journeyStarted", ascending: true)
            fetchRequest.sortDescriptors = [sorter]
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "journeyStarted", cacheName: nil)
            fetchedResultController!.delegate = self as NSFetchedResultsControllerDelegate
        }

        let userPredicate = NSPredicate(format: "user == %@", user)
        let datePredicate = NSPredicate(format: "journeyStarted >= %@ AND journeyStarted < %@ ", startDate, endDate)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])
        fetchedResultController?.fetchRequest.predicate = andPredicate
        
        do {
            try fetchedResultController!.performFetch()
            guard let values = self.fetchedResultController?.fetchedObjects! else {
                return
            }
            for x in values {
                userJourneys.append(x)
            }
            
        } catch {
            print("fetch failed")
        }
    }
    
    func setDateHeader(date: NSDate){
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd-MM-YYYY"
        let date = formatter.string(from: startDate as Date)
        self.title = String(date)
    }
    

    func setDailyInfo(){
        var distance = 0
        var time = TimeInterval()
        var co2 = Double()
        var dailyInfo = [Dictionary<String, Double>]()
        var modeTransports: [String : Double] = [:]
        
        
        for journey in userJourneys {

            for segment in journey.journeySegment ?? []  {
                let s = segment as! JourneySegment
                distance = distance + Int(s.segmentDistanceTravelled)
                
                let diffInSeconds = s.segmentEnd?.timeIntervalSince(s.segmentStart!)
                time = time + diffInSeconds!
                
                modeTransports[String(s.segmentModeOfTravel!)] = Double(diffInSeconds!)
                
                co2 = co2 + s.segmentCo2
            }
            let totalDistance = ["Distance Travelled": Double(distance)]
            dailyInfo.append(totalDistance)
            let totalTime = ["Time Spent Travelling" : time]
            dailyInfo.append(totalTime)
            let totalCO2 = ["Total CO2 Emmissions" : co2]
            dailyInfo.append(totalCO2)
 
        }
        
        dailyDetails = Details(dailyInfo: dailyInfo, transports: modeTransports)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        else {
            return userJourneys.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.identifier, for: indexPath) as! PieChartTableViewCell
            guard let data = dailyDetails?.pieChartData else {
                return cell
            }
            cell.configure(pieChartDataArray: data)
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CarbonDetailsTableViewCell.identifier, for: indexPath) as! CarbonDetailsTableViewCell
            
            if !userJourneys.isEmpty{
                
                cell.configure(dailyInfo: dailyDetails!)
                
                cell.selectionStyle = .none
                return cell
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: JourneyOverviewCell.identifier, for: indexPath) as! JourneyOverviewCell
            cell.name.text = userJourneys[indexPath.row].journeyName
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
            journeySelected = userJourneys[indexPath.row]
            performSegue(withIdentifier: "showDetails", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! JourneyDetailsViewController
        destVC.receivedJourney = journeySelected
        self.tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 300
        }
        else if indexPath.section == 1 {
            return 300
        }
        else {
            return 100
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller change content")
        tableView.reloadData()
    }
    
}


