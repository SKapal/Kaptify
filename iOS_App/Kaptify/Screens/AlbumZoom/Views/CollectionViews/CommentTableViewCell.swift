//
//  CommentTableViewCell.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-08.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

final class CommentTableViewCell: UITableViewCell {
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var separatorLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var commentLabel: UILabel!
    
    override func awakeFromNib() {
        usernameLabel.textColor = UIColor(r: 255, b: 157, g: 41)
        separatorLabel.textColor = .white
        self.backgroundColor = .red
        dateLabel.textColor = .white
        commentLabel.textColor = .white
        commentLabel.preferredMaxLayoutWidth = self.frame.width
    }
}
