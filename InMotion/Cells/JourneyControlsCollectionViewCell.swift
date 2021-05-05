//
//  JourneyControlsCollectionViewCell.swift
//  InMotion
//
//  Created by iosdev on 4.5.2021.
//

import UIKit
import CoreData

class JourneyControlsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleBtn: UIButton!
    @IBOutlet weak var favToggle: UISwitch!
    
    var journeyReceived: Journey!
    var delegate: JourneyControlsCellDelegate!
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        delegate.deleteBtn()
    }
    
    
    @IBAction func favouriteToggled(_ sender: Any) {
        print("Toggled pressed")
        CoreHelper.instance.updateFavouriteJourney(journey: journeyReceived)
    }
    
    static var identifier = "JourneyControlsCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "JourneyControlsCollectionViewCell", bundle: nil)
    }

    func configure(journey: Journey){
        journeyReceived = journey
        favToggle.isOn = journey.favourite

    }
}

protocol JourneyControlsCellDelegate {
    func deleteBtn()
}
