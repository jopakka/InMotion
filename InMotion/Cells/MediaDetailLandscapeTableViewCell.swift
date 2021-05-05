//
//  MediaDetailLandscapeTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 5.5.2021.
//

import UIKit

class MediaDetailLandscapeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var descriptionText: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    static var identifier = "MediaDetailLandscapeTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MediaDetailLandscapeTableViewCell", bundle: nil)
    }
    
    func configure(image: UIImage, title: String, description: String){
        cellImage.image = image
        titleText.text = title
        descriptionText.text = description
    }
    
}
