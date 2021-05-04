//
//  JourneyControlsCollectionViewCell.swift
//  InMotion
//
//  Created by iosdev on 4.5.2021.
//

import UIKit

class JourneyControlsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var deleBtn: UIButton!
    @IBOutlet weak var favToggle: UISwitch!
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        print("save pressed")
    }
    
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        print("delete pressed")
    }
    
    
    @IBAction func favouriteToggled(_ sender: Any) {
        print("Toggled pressed")
    }
    
    static var identifier = "JourneyControlsCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "JourneyControlsCollectionViewCell", bundle: nil)
    }

}
