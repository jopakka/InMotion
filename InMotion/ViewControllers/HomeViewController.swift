//
//  HomeViewController.swift
//  InMotion
//
//  Created by Joonas Niemi on 26.4.2021.
//

import UIKit
import MOPRIMTmdSdk
import CoreData

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // Text fields
    @IBOutlet weak var fullnameTf: UILabel!
    
    // Image views
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    
    // Table view
    @IBOutlet weak var favouriteTableView: UITableView!
    
    private var user: User!
    private var journeySelected: Journey?
    private var fetchedResultController: NSFetchedResultsController<Journey>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navbar gradient
        let image = self.navigationController!.getGradient()
        self.navigationController!.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        
        user = UserHelper.instance.user
        if user == nil {
            // TODO: This should log user out
            NSLog("No user. Logging out")
            return
        }
        
        favouriteTableView.delegate = self
        favouriteTableView.dataSource = self
        
        let routeNib = UINib(nibName: "JourneyOverviewCell", bundle: nil)
        favouriteTableView.register(routeNib, forCellReuseIdentifier: "JourneyOverviewCell")
        
        updateInfos()
        
        setRoutesToTableView()
    }
    
    // Fetches routes from core data and sets controller for those
    private func setRoutesToTableView() {
        if fetchedResultController == nil {
            let managedContext = AppDelegate.viewContext
            let fetchRequest: NSFetchRequest<Journey> = Journey.fetchRequest()
            let sorter = NSSortDescriptor(key: "journeyStarted", ascending: true)
            fetchRequest.sortDescriptors = [sorter]
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "journeyStarted", cacheName: nil)
            fetchedResultController!.delegate = self as NSFetchedResultsControllerDelegate
        }
        
        // Fetch only favourited ones
        let userPredicate = NSPredicate(format: "user == %@", user)
        let favPredicate = NSPredicate(format: "favourite == true")
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, favPredicate])
        fetchedResultController?.fetchRequest.predicate = andPredicate
        
        do {
            try fetchedResultController!.performFetch()
            favouriteTableView.reloadData()
        } catch {
            print("fetch failed")
        }
    }
    
    // Updates displayed values
    private func updateInfos() {
        fullnameTf.text = "\(user.firstname ?? "") \(user.lastname ?? "")"
        
        var profileImage = UIImage(systemName: "person.fill")
        if user.avatarImg != nil {
            profileImage = UIImage(data: user.avatarImg!)!
        }
        profileImageView.image = profileImage
        
        var bannerImage = UIImage(named: "loginBackground")
        if user.bannerImg != nil {
            bannerImage = UIImage(data: user.bannerImg!)!
        }
        bannerImageView.image = bannerImage
    }

    

}

// MARK: Favourite routes table view stuffs
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController!.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JourneyOverviewCell", for: indexPath) as! JourneyOverviewCell
        
        guard let journeyItem = self.fetchedResultController?.object(at: indexPath) else {
            fatalError("Journey not found in contoller")
        }
        
        cell.configureCell(journey: journeyItem)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        journeySelected = self.fetchedResultController?.object(at: indexPath)
        performSegue(withIdentifier: "showDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! JourneyDetailsViewController
        let indexPath = favouriteTableView.indexPathForSelectedRow
        destVC.receivedJourney = journeySelected
        self.favouriteTableView.deselectRow(at: indexPath!, animated: true)
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Controller change content")
        favouriteTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController!.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UINavigationController {
    
    func getGradient() -> UIImage? {
        
        // code found when researching gradients for navbars
        // https://stackoverflow.com/questions/50285911/how-to-add-vertical-gradient-color-in-uinavigationbar
        
        let gradientLayer = CAGradientLayer()
        var updatedFrame = self.navigationController!.navigationBar.bounds
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        updatedFrame.size.height += statusBarHeight
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.link.cgColor, UIColor.blue.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // vertical gradient start
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // vertical gradient end

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
}
