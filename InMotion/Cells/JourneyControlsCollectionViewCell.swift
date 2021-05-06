//
//  JourneyControlsCollectionViewCell.swift
//  InMotion
//
//  Created by Michael Carter on 4.5.2021.
//

import UIKit
import CoreData

// Class with controlled to delete and update favourite journeys
class JourneyControlsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deleBtn: UIButton!
    @IBOutlet weak var favToggle: UISwitch!
    @IBOutlet weak var favouriteLabel: UILabel!
    
    // access to identifier
    static var identifier = "JourneyControlsCollectionViewCell"
    var journeyReceived: Journey!
    // cell delegate
    var delegate: JourneyControlsCellDelegate!
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        delegate.deleteBtn()
    }
    
    // updates core data on selected journeys favourite status
    @IBAction func favouriteToggled(_ sender: Any) {
        CoreHelper.instance.updateFavouriteJourney(journey: journeyReceived)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // access to cell nib
    static func nib() -> UINib {
        return UINib(nibName: "JourneyControlsCollectionViewCell", bundle: nil)
    }
    
    // cell configuration
    func configure(journey: Journey){
        journeyReceived = journey
        favouriteLabel.text = NSLocalizedString("Favourite", comment: "Favourite")
        favToggle.isOn = journey.favourite
        
    }
}

protocol JourneyControlsCellDelegate {
    func deleteBtn()
}
