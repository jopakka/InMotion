//
//  ImagePostCollectionViewCell.swift
//  InMotion
//
//  Created by iosdev on 28.4.2021.
//

import UIKit

class ImagePostCollectionViewCell: UICollectionViewListCell {

    @IBOutlet var imageView: UIImageView!
    
    static var identifier = "ImagePostCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(with image: UIImage){
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ImagePostCollectionViewCell", bundle: nil)
    }
}
