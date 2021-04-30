//
//  MediaDetailsTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 30.4.2021.
//

import UIKit

class MediaDetailsTableViewCell: UITableViewCell {
 
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    static var identifier = "MediaDetailsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MediaDetailsTableViewCell", bundle: nil)
    }
    
    func configure(image: UIImage, title: String, description: String){
        cellImage.image = image
        titleText.text = title
        descriptionText.text = description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
