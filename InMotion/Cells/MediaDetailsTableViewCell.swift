//
//  MediaDetailsTableViewCell.swift
//  InMotion
//
//  Created by Michael Carter on 30.4.2021.
//

import UIKit

// Class to display detailed image and blog post on cell
class MediaDetailsTableViewCell: UITableViewCell, MediaDetailsCellDelegate {
    
    // cell delegate
    var delegate: MediaDetailsCellDelegate!
    var postVar: Post!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionView: UILabel!
    
    //when delete button is pressed on cell called function from delegate VC
    @IBAction func postDeleteBtn(_ sender: Any) {
        delegate.deleteBtn(post: postVar)
    }
    
    // access to identifier
    static var identifier = "MediaDetailsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // access to nib
    static func nib() -> UINib {
        return UINib(nibName: "MediaDetailsTableViewCell", bundle: nil)
    }
    
    // configure cell
    func configure(post: Post){
        postVar = post
        postImage.image = UIImage(data:post.postImg!)!
        titleView.text = post.postTitle
        descriptionView.text = post.postBlog
    }
    
    // cell delegate function
    func deleteBtn(post: Post) {
        delegate.deleteBtn(post: post)
    }
    
}

// Protocol to add delete function
protocol MediaDetailsCellDelegate {
    func deleteBtn(post: Post)
}
