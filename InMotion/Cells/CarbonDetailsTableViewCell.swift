//
//  CarbonDetailsTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import UIKit

class CarbonDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet var distanceTravelled: UILabel!
    @IBOutlet var timeTravelled: UILabel!
    @IBOutlet var emissions: UILabel!
    @IBOutlet var popularTransport: UILabel!
    
    static var identifier = "CarbonDetailsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CarbonDetailsTableViewCell", bundle: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)

    }
    
    func configure(dailyInfo: DailyDetails){
        let time = secondsToHoursMinutesSeconds(seconds: Int(dailyInfo.timeTravelledInSeconds))

        distanceTravelled.text = String(format: "%.0f km",
                                        dailyInfo.distanceTravelled)
        timeTravelled.text = String(format: "%d hr %d min %d sec",
                                    time.0,
                                    time.1,
                                    time.2)
        emissions.text = String(format: "%.1f g/km",
                                dailyInfo.co2Emissions)
        popularTransport.text = dailyInfo.popularTransport
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}




