//
//  CommentModel.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-22.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation

struct Comment {
    let username: String?
    let date: String?
    let comment: String?
    
    init(username: String, date: String, comment: String) {
        self.username = username
        self.date = date
        self.comment = comment
    }
}
