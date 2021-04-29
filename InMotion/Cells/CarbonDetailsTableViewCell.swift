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
    
    func configure(distanceTravelled distance: String, timeTravelled time: String, emmissions carbon: String, popularTransport transport: String){
        distanceTravelled.text = distance
        timeTravelled.text = time
        emissions.text = carbon
        popularTransport.text = transport
    }
    
    

}

