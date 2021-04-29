//
//  pieChartTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 29.4.2021.
//

import UIKit

class PieChartTableViewCell: UITableViewCell {

    static var identifier = "PieChartTableViewCell"
    
    @IBOutlet weak var pieChartImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with image: UIImage){
        pieChartImage.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PieChartTableViewCell", bundle: nil)
    }
    
}
