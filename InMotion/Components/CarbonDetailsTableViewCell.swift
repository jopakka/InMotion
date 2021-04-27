//
//  CarbonDetailsTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import UIKit

class CarbonDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet var carbonAnswer1: UILabel!
    @IBOutlet var carbonAnswer2: UILabel!
    @IBOutlet var carbonAnswer3: UILabel!
    @IBOutlet var carbonAnswer4: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)

    }
    
}

