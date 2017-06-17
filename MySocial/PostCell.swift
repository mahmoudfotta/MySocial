//
//  PostCell.swift
//  MySocial
//
//  Created by mahmoud gamal on 6/17/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit

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



}
