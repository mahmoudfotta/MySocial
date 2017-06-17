//
//  CircleImageView.swift
//  MySocial
//
//  Created by mahmoud gamal on 6/16/17.
//  Copyright © 2017 mahmoud gamal. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
