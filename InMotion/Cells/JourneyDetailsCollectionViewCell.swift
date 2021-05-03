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
    
    static let identifier = "JourneyDetailsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "JourneyDetailsCollectionViewCell", bundle: nil)
    }

    func configure(journey: Details, title: String){
        
        let time = secondsToHoursMinutesSeconds(seconds: Int(journey.timeTravelledInSeconds))

        distanceTravelled.text = String(format: "%.2f km",
                                        journey.distanceTravelled)
        timeTravelled.text = String(format: "%d hr %d min %d sec",
                                    time.0,
                                    time.1,
                                    time.2)
        emissions.text = String(format: "%.1f g",
                                journey.co2Emissions)
        popularTransport.text = journey.popularTransport
        journeyTitle.text = title.capitalized
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
