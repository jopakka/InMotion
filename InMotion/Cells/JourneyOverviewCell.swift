//
//  JourneyOverviewCell.swift
//  InMotion
//
//  Created by iosdev on 27.4.2021.
//

import UIKit

class JourneyOverviewCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var photoView: UIImageView!
    
    static var identifier = "JourneyOverviewCell"

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
        roundCorners(corners: [.topLeft, .bottomLeft], radius: 20.0)
        let margins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        contentView.frame = contentView.frame.inset(by: margins)

    }
    
    static func nib() -> UINib {
        return UINib(nibName: "JourneyOverviewCell", bundle: nil)
    }
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
