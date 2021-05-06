//
//  JourneyDetailsCollectionViewCell.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import UIKit

class JourneyDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var distanceTravelled: UILabel!
    @IBOutlet weak var timeTravelled: UILabel!
    @IBOutlet weak var emissions: UILabel!
    @IBOutlet weak var popularTransport: UILabel!
    @IBOutlet weak var journeyTitle: UILabel!
    
    // Access identifier
    static let identifier = "JourneyDetailsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // Generates nib
    static func nib() -> UINib {
        return UINib(nibName: "JourneyDetailsCollectionViewCell", bundle: nil)
    }
    
    // Configure cell
    func configure(journey: Details, title: String){
        
        let time = secondsToHoursMinutesSeconds(seconds: Int(journey.timeTravelledInSeconds))
        
        // Using string formats to display data correctly
        distanceTravelled.text = String(format: "%.2f km",
                                        journey.distanceTravelled)
        timeTravelled.text = String(format: "%d hr %d min %d sec",
                                    time.0,
                                    time.1,
                                    time.2)
        emissions.text = String(format: "%.3f kg",
                                journey.co2Emissions)
        popularTransport.text = journey.popularTransport
        journeyTitle.text = title.capitalized
        
    }
    
    // Converts a time interval into hours, minutes and seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
