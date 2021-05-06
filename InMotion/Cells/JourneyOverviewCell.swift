//
//  JourneyOverviewCell.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import UIKit

class JourneyOverviewCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var photoView: UIImageView!
    @IBOutlet weak var distanceTravelled: UILabel!
    @IBOutlet weak var decorationView: UIView!
    
    static var identifier = "JourneyOverviewCell"
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        name.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .bottomLeft], radius: 2.0)
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)

    }
    
    func configureCell(journey: Journey){
        
        let details = setDailyInfo(journey: journey)
        var postArray = [Data]()
        var postImage: UIImage?
        
        for posts in journey.posts ?? [] {
            let post = posts as! Post

            postArray.append(post.postImg!)
        }
        
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
    
    static func nib() -> UINib {
        return UINib(nibName: "JourneyOverviewCell", bundle: nil)
    }
    
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

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
