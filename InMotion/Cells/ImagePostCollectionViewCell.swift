//
//  ImagePostCollectionViewCell.swift
//  InMotion
//
//  Created by Michael Carter on 28.4.2021.
//

import UIKit

// Display an image to a collection cell
class ImagePostCollectionViewCell: UICollectionViewListCell {
    
    @IBOutlet var imageView: UIImageView!
    
    // access to identifier
    static var identifier = "ImagePostCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    // configure cell
    public func configure(with image: UIImage){
        imageView.image = image
    }
    
    // Generates nib
    static func nib() -> UINib {
        return UINib(nibName: "ImagePostCollectionViewCell", bundle: nil)
    }
    
    
}
