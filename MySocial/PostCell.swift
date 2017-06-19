//
//  PostCell.swift
//  MySocial
//
//  Created by mahmoud gamal on 6/17/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: CircleImageView!
    
    @IBOutlet weak var likeImg: CircleImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var captionTxtView: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil ) {
        self.likesLbl.text = "\(post.likes)"
        self.captionTxtView.text = post.caption
       
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error == nil {
                    self.postImg.image = UIImage(data: data!)
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }
}



