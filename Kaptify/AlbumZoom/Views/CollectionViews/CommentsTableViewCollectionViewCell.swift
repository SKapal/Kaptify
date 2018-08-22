//
//  CommentsTableViewCollectionViewCell.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-22.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation
import UIKit

class CommentsTableViewCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    let cellIdentifier = "commentCellIdentifier"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CommentTableViewCell
        
        cell.usernameLabel.text = "Splashbruh"
        cell.dateLabel.text = "Today"
        cell.commentLabel.text = "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been is simply dummy text of the is simply dummy text of the printing and typesetting industry. \n\nLorem Ipsum has been is simply dummy text of the is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been is simply dummy text of the is simply dummy text of the printing and typesetting industry. \n\nLorem Ipsum has been is simply dummy text of the"
        cell.backgroundColor = .clear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
        
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.setupTableView()
        
    }
    func setupTableView() {
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
