//
//  CommentsTableViewCollectionViewCell.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-22.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation
import UIKit

class CommentsTableViewCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView = UITableView()
    let cellIdentifier = "commentCellIdentifier"
    
    let commentField: UITextField = {
        let tf = UITextField()
        let font = UIFont(name: "HelveticaNeue-Light", size: 17)
        tf.font = font
        tf.textColor = .white
        tf.placeholder = "Add comment"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        let postImage = UIImage(named: "post")?.withRenderingMode(.alwaysOriginal)
        let postIV = UIImageView(image: postImage)
        postIV.contentMode = .scaleAspectFit
        button.setImage(postIV.image, for: .normal)
        
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handlePost() {
        print(123)
    }
    
    let blur: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurredView = UIVisualEffectView(effect: blur)
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        return blurredView
    }()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CommentTableViewCell
        cell.selectionStyle = .none
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
        self.addSubview(commentField)
        self.insertSubview(blur, aboveSubview: tableView)
//        self.insertSubview(postButton, aboveSubview: blur)
        self.addSubview(postButton)
        

        self.setupTableView()
        self.setupCommentField()
        self.setupBlur()
        self.setupPostButton()
        
    }
    
    func setupPostButton() {
        postButton.rightAnchor.constraint(equalTo: blur.rightAnchor, constant: -16).isActive = true
        postButton.topAnchor.constraint(equalTo: commentField.topAnchor).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupBlur() {
        blur.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        blur.topAnchor.constraint(equalTo: commentField.topAnchor, constant: -10).isActive = true
        blur.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupCommentField() {
        commentField.delegate = self
        commentField.leftAnchor.constraint(equalTo: blur.leftAnchor, constant: 16).isActive = true
        commentField.rightAnchor.constraint(equalTo: postButton.leftAnchor, constant: -16).isActive = true
        commentField.bottomAnchor.constraint(equalTo: self.blur.bottomAnchor, constant: -10).isActive = true
        commentField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentField.resignFirstResponder()
        return true
    }
    
    func setupTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
        
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)

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
