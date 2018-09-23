//
//  ProfileTableViewCell.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-09-19.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var activityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
