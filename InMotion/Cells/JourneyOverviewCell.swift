//
//  JourneyOverviewCell.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import UIKit

// TableView cell that handles a saved journey allowing access to the user
class JourneyOverviewCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet weak var distanceTravelled: UILabel!
    @IBOutlet weak var decorationView: UIView!
    
    // Access to cell identifier
    static var identifier = "JourneyOverviewCell"
    
    // Shadow settings
    var cornerRadius: CGFloat = 2
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 3
    var shadowColor: UIColor? = UIColor.black
    var shadowOpacity: Float = 0.5
    
    // Uses a nib to create the layout of the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.backgroundColor = .clear
        
        decorationView.layer.backgroundColor = UIColor.clear.cgColor
        decorationView.layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: decorationView.layer.bounds, cornerRadius: cornerRadius)
        
        decorationView.layer.masksToBounds = false
        decorationView.layer.shadowColor = shadowColor?.cgColor
        decorationView.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        decorationView.layer.shadowOpacity = shadowOpacity
        decorationView.layer.shadowPath = shadowPath.cgPath
        decorationView.backgroundColor = UIColor.systemYellow
        
    }
    
    // Used to add corner radius to the left side only and add in padding to the frame
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .bottomLeft], radius: 2.0)
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
        
    }
    
    // Config function for displaying data on cell
    func configureCell(journey: Journey){
        // Access to processed journey information
        let details = setDailyInfo(journey: journey)
        
        // Post images in an array
        var postArray = [Data]()
        
        var postImage: UIImage?
        
        // Appending post images to array from core data faults
        for posts in journey.posts ?? [] {
            let post = posts as! Post
            postArray.append(post.postImg!)
        }
        
        // check for images else display a placeholder
        if postArray.isEmpty {
            postImage = UIImage(named: "loginBackground")
        }else {
            postImage = UIImage(data: postArray.randomElement()!)
        }
        
        
        name.text = journey.journeyName
        photoView.image = postImage
        photoView.clipsToBounds = true
        photoView.layer.masksToBounds = true
        photoView.contentMode = .scaleAspectFill
        distanceTravelled.text = String(format: "%.2f km",
                                        details.distanceTravelled)
    }
    
    // Creates the nib required for registering to tableView
    static func nib() -> UINib {
        return UINib(nibName: "JourneyOverviewCell", bundle: nil)
    }
    
    // Process journey data from the associated journey segment property
    func setDailyInfo(journey: Journey) -> Details{
        var distance = 0
        var time = 0.0
        var co2 = Double()
        var dailyInfo = [Dictionary<String, Double>]()
        var modeTransports: [Int: [String : Double]] = [:]
        var count = 0
        var dailyDetails: Details?
        
        
        for segment in journey.journeySegment ?? []  {
            let s = segment as! JourneySegment
            distance = distance + Int(s.segmentDistanceTravelled)
            
            let diffInSeconds = s.segmentEnd?.timeIntervalSince(s.segmentStart!)
            time = time + diffInSeconds!
            
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
        dailyDetails = Details(dailyInfo: dailyInfo, transports: modeTransports)
        
        return dailyDetails!
    }
    
    
    
}

// Added functionality to UIView for specific corners to curve.
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
