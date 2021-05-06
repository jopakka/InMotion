//
//  CarbonDetailsTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import UIKit

// Displays carbon details and other facts about journeys accumilated over a single day
class CarbonDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet var distanceTravelled: UILabel!
    @IBOutlet var timeTravelled: UILabel!
    @IBOutlet var emissions: UILabel!
    @IBOutlet var popularTransport: UILabel!
    
    // Identifier access
    static var identifier = "CarbonDetailsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Nib access
    static func nib() -> UINib {
        return UINib(nibName: "CarbonDetailsTableViewCell", bundle: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)
        
    }
    // Cell configuration
    func configure(dailyInfo: Details){
        let time = secondsToHoursMinutesSeconds(seconds: Int(dailyInfo.timeTravelledInSeconds))
        
        // String formatting to display data in a specific way
        distanceTravelled.text = String(format: "%.2f km",
                                        dailyInfo.distanceTravelled)
        timeTravelled.text = String(format: "%d hr %d min %d sec",
                                    time.0,
                                    time.1,
                                    time.2)
        emissions.text = String(format: "%.3f kg",
                                dailyInfo.co2Emissions)
        popularTransport.text = dailyInfo.popularTransport
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}




