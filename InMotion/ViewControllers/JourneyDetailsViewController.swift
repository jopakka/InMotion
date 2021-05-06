//
//  JourneyDetailsViewController.swift
//  InMotion
//
//  Created by iosdev on 17.4.2021.
//

import UIKit
import CoreData

class JourneyDetailsViewController: UIViewController, NSFetchedResultsControllerDelegate, JourneyControlsCellDelegate{
    
    var receivedJourney: Journey?
    var postToSend: String?
    var post: Post?
    var journeyDetails: Details?
    var arrayOfPolyline: [String?: String?] = [:]
    var imageArray = [Post]()
    let managedContext = AppDelegate.viewContext
    var isLandscape: Bool!
    
    private var fetchedResultController: NSFetchedResultsController<Journey>?
    var user: User!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if let interfaceOrientation = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.windowScene?.interfaceOrientation {
         // Use interfaceOrientation
            print("interfaceOrientation: ", interfaceOrientation.isLandscape)
            
            if interfaceOrientation.isLandscape{
                isLandscape = true
            }else{
                isLandscape = false
            }
            
        }
        
        print("isLandscaping: ", isLandscape!)
        
        user = UserHelper.instance.user
        if user == nil {
            // TODO: This should log user out
            NSLog("No user. Logging out")
            return
        }
        
        
        collectionView.setCollectionViewLayout(JourneyDetailsViewController.createLayout(isLandscape: isLandscape), animated: true)
        
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
    
    static func createMapCellLayout(landscape: Bool) -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize
        if landscape{
           itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1.0))
        }else {
            itemSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1),
             heightDimension: .fractionalWidth(2/3))
        }
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        if landscape{
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let space = screenWidth * 0.05
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: space, bottom: 0, trailing: space)
        }

        return section
    }
    
    static func createDetailCellLayout() -> NSCollectionLayoutSection {
        

         let itemSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1),
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
    
    static func createLayout(isLandscape: Bool) -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 {
                return self.createMapCellLayout(landscape: isLandscape)
            }else if sectionIndex == 1 {
                return self.createControlLayout()
            }else if sectionIndex == 2 {
                return self.createDetailCellLayout()
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
    
    
    func deleteBtn() {
        // Create the actions
        
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            self.navigationController?.popToRootViewController(animated: false)
            CoreHelper.instance.deleteJourney(journey: self.receivedJourney!)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }
        AlertHelper.instance.showDeleteConfirmationAlert(title: "Comfirm Delete?", message: "Are you sure you want to delete this Journey? It will be permanent!", presenter: self, actions: [okAction, cancelAction])
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
    
    override func willRotate(to toInterfaceOrientation:
                                            UIInterfaceOrientation, duration: TimeInterval) {
  
        isLandscape = orientationCheck()

        self.collectionView.setCollectionViewLayout(JourneyDetailsViewController.createLayout(isLandscape: isLandscape), animated: true)
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func orientationCheck()  -> Bool {
        switch UIDevice.current.orientation{
        case .portrait:
            print("portrait")
            return false
        case .portraitUpsideDown:
            print("portraitUpside")
            return false
        case .landscapeLeft:
            print("landscapeLeft")
            return true
        case .landscapeRight:
            print("landscapeRight")
            return true
        default:
            print("default")
            return false
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
            cell.delegate = self
            cell.configure(journey: receivedJourney!)
            return cell
        }
        else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyDetailsCollectionViewCell.identifier, for: indexPath) as! JourneyDetailsCollectionViewCell
            
            if receivedJourney?.journeyName == nil{
                self.navigationController?.popToRootViewController(animated: false)
            }
            else{
                cell.configure(journey: journeyDetails!, title: receivedJourney?.journeyName ?? "no data")
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePostCollectionViewCell.identifier, for: indexPath) as! ImagePostCollectionViewCell
            
            cell.imageView.image = UIImage(data:imageArray[indexPath.row].postImg!)
            return cell
        }
        
    }
}


