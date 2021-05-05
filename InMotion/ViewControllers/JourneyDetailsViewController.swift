//
//  JourneyDetailsViewController.swift
//  InMotion
//
//  Created by iosdev on 17.4.2021.
//

import UIKit
import CoreData

class JourneyDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate{
    
    
    
    var receivedJourney: Journey?
    var postToSend: String?
    var post: Post?
    var journeyDetails: Details?
    var arrayOfPolyline: [String?: String?] = [:]
    var imageArray = [Post]()
    let managedContext = AppDelegate.viewContext
    
    private var fetchedResultController: NSFetchedResultsController<Journey>?
    var user: User!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        user = UserHelper.instance.user
        if user == nil {
            // TODO: This should log user out
            NSLog("No user. Logging out")
            return
        }
        

        collectionView.setCollectionViewLayout(JourneyDetailsViewController.createLayout(), animated: true)
        
        collectionView.register(JourneyControlsCollectionViewCell.nib(), forCellWithReuseIdentifier: JourneyControlsCollectionViewCell.identifier)
        collectionView.register(JourneyDetailsCollectionViewCell.nib(), forCellWithReuseIdentifier: JourneyDetailsCollectionViewCell.identifier)
        collectionView.register(ImagePostCollectionViewCell.nib(), forCellWithReuseIdentifier: ImagePostCollectionViewCell.identifier)
        collectionView.register(MapCollectionViewCell.nib(), forCellWithReuseIdentifier: MapCollectionViewCell.identifier)
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchJourney()
        setDailyInfo()
        getImages()
        
    }
    
    func fetchJourney(){
        if fetchedResultController == nil {
            let fetchRequest: NSFetchRequest<Journey> = Journey.fetchRequest()
            fetchRequest.returnsObjectsAsFaults = false
            let sorter = NSSortDescriptor(key: "journeyStarted", ascending: true)
            fetchRequest.sortDescriptors = [sorter]
            fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "journeyStarted", cacheName: nil)
            fetchedResultController!.delegate = self as NSFetchedResultsControllerDelegate
        }
        
        let userPredicate = NSPredicate(format: "user == %@", user)
        let journeyIdPredicate = NSPredicate(format: "journeyId == %@", (receivedJourney?.journeyId)! as CVarArg)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, journeyIdPredicate])
        fetchedResultController?.fetchRequest.predicate = andPredicate
        
        do {
            try fetchedResultController!.performFetch()
            receivedJourney = fetchedResultController?.fetchedObjects![0]
            print("fetched Journey successful")
            
        } catch {
            print("fetch failed")
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
    
    static func createControlLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    static func createSingleCellLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    static func createImageLayout() -> NSCollectionLayoutSection{
        //item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1))
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let verticalStackItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(0.5)
            )
        )
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(
            top: 2, leading: 2, bottom: 2, trailing: 2)
        
        
        //group
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1)
            ),
            subitem: verticalStackItem,
            count: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(3/5)),
            subitems: [
                item,
                verticalGroup
            ]
        )
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 || sectionIndex == 2 {
                return self.createSingleCellLayout()
            }else if sectionIndex == 1 {
                return self.createControlLayout()
            }
            else{
                return self.createImageLayout()
            }
        }
        return layout
    }
    
    func setDailyInfo(){
        var distance = 0
        var time = TimeInterval()
        var co2 = Double()
        var dailyInfo = [Dictionary<String, Double>]()
        var modeTransports: [Int: [String : Double]] = [:]
        var count = 0
        
        
        for segment in receivedJourney!.journeySegment! {
            let s = segment as! JourneySegment
            
            distance = distance + Int(s.segmentDistanceTravelled)
            
            let diffInSeconds = s.segmentEnd?.timeIntervalSince(s.segmentStart!)
            time = time + diffInSeconds!
            
            arrayOfPolyline[s.segmentModeOfTravel] = s.segmentEncodedPolyLine
            
            modeTransports[count] = [String(s.segmentModeOfTravel!): Double(diffInSeconds!)]
            count = count + 1
            co2 = co2 + s.segmentCo2
        }
        let totalDistance = ["Distance Travelled": Double(distance)]
        dailyInfo.append(totalDistance)
        let totalTime = ["Time Spent Travelling" : time]
        dailyInfo.append(totalTime)
        let totalCO2 = ["Total CO2 Emmissions" : co2]
        dailyInfo.append(totalCO2)
        
        
        
        journeyDetails = Details(dailyInfo: dailyInfo, transports: modeTransports)
        
        
    }
    
    func getImages(){
        
        for image in receivedJourney!.posts! {
            let post = image as! Post
            imageArray.append(post)
        }
    }
    
}

extension JourneyDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            print("image pressed")
            post = imageArray[indexPath.row]
            performSegue(withIdentifier: "showPostDetails", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPostDetails" {
            
            let destVC = segue.destination as! JourneyMediaDetailsViewController
            destVC.receivedPost = post!
        }
        
    }
    
    
}

extension JourneyDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 || section == 2{
            return 1
        }else {
            return imageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCollectionViewCell.identifier, for: indexPath) as! MapCollectionViewCell
            
            cell.configure(with: receivedJourney!)
            return cell
        }
        else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyControlsCollectionViewCell.identifier, for: indexPath) as! JourneyControlsCollectionViewCell
            
            return cell
        }
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyDetailsCollectionViewCell.identifier, for: indexPath) as! JourneyDetailsCollectionViewCell
            
            cell.configure(journey: journeyDetails!, title: (receivedJourney?.journeyName)!)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePostCollectionViewCell.identifier, for: indexPath) as! ImagePostCollectionViewCell
            
            cell.imageView.image = UIImage(data:imageArray[indexPath.row].postImg!)
            return cell
        }
        
    }
}


