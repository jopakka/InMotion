//
//  MediaDetailsTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 30.4.2021.
//

import UIKit

class MediaDetailsTableViewCell: UITableViewCell {
 
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionView: UILabel!
    
    static var identifier = "MediaDetailsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MediaDetailsTableViewCell", bundle: nil)
    }
    
    func configure(image: UIImage, title: String, description: String){
        postImage.image = image
        titleView.text = title
        descriptionView.text = description
    }
    
}
