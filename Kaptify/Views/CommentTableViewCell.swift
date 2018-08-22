//
//  CommentTableViewCell.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-08.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        usernameLabel.textColor = UIColor(r: 255, b: 157, g: 41)
        separatorLabel.textColor = .white
        self.backgroundColor = .red
        dateLabel.textColor = .white
        commentLabel.textColor = .white
        commentLabel.preferredMaxLayoutWidth = self.frame.width
        
        
    }

}
