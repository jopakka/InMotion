//
//  MediaDetailsTableViewCell.swift
//  InMotion
//
//  Created by iosdev on 30.4.2021.
//

import UIKit

class MediaDetailsTableViewCell: UITableViewCell, MediaDetailsCellDelegate {
    func deleteBtn(post: Post) {
        delegate.deleteBtn(post: post)
    }
    

    var delegate: MediaDetailsCellDelegate!
    var postVar: Post!
 
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionView: UILabel!
    
    @IBAction func postDeleteBtn(_ sender: Any) {
        delegate.deleteBtn(post: postVar)
    }
    static var identifier = "MediaDetailsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "MediaDetailsTableViewCell", bundle: nil)
    }
    
    func configure(post: Post){
        postVar = post
        postImage.image = UIImage(data:post.postImg!)!
        titleView.text = post.postTitle
        descriptionView.text = post.postBlog
    }
    
}

protocol MediaDetailsCellDelegate {
    func deleteBtn(post: Post)
}
