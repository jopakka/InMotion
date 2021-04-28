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
    
    static let identifier = "JourneyDetailsCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "JourneyDetailsCollectionViewCell", bundle: nil)
    }

}
