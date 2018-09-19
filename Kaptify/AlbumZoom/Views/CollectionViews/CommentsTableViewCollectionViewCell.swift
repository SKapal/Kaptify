//
//  CommentsTableViewCollectionViewCell.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-22.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class CommentsTableViewCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView = UITableView()
    let cellIdentifier = "commentCellIdentifier"
    var fBaseRef: DatabaseReference?
    
    var parent: HorizontalCollection?
    
    var comments = [Comment]()
    
    let commentField: UITextField = {
        let tf = UITextField()
        let font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        tf.font = font
        tf.textColor = .white
        tf.placeholder = "Add comment"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handlePost() {
        guard let comment = self.commentField.text, let user = Auth.auth().currentUser, let albumID = parent?.selectedAlbumId, let username = user.displayName else { return }
        if !(comment.count > 0) {
            commentField.resignFirstResponder()
            return
        }

        guard let commentsRef = fBaseRef?.child("Comments"), let post = fBaseRef?.child("Comments").childByAutoId(), let albumRef = fBaseRef?.child("Albums").child(albumID), let userRef = fBaseRef?.child("Users").child(user.uid) else {return}
        let dispatchGroup = DispatchGroup()
        
        // add to Comments block
        dispatchGroup.enter()
        commentsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            post.child(albumID).setValue(true)
            post.child(user.uid).setValue(true)
            post.child("Username").setValue(username)
            post.child("Comment").setValue(comment)
            post.child("Date").setValue(self.getDate())
            self.comments.append(Comment(username: username, date: self.getDate(), comment: comment))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
            commentsRef.observeSingleEvent(of: .value) { (snapshot) in
                for comment in snapshot.children {
                    guard let commentSnap = comment as? DataSnapshot else {return}
                    if let value = commentSnap.childSnapshot(forPath: albumID).value as? Bool {
                        if value == true {
                            let commentID = commentSnap.key
                            // add to Album block
                            albumRef.child("Comments").child(commentID).setValue(true)
                            albumRef.child("Comments_by").child(user.uid).setValue(true)
                            // add to User block
                            userRef.child("Commented_albums").child(albumID).setValue(true)
                            userRef.child("Comments").child(commentID).setValue(true)
                        }
                    }
                }
            }
        }
        

        commentField.text = ""
        commentField.resignFirstResponder()
        
    }
    
    func getDate() -> String {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return "\(day)/\(month)/\(year) \(hour):\(minute)"
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
        cell.usernameLabel.text = comments[indexPath.row].username
        cell.dateLabel.text = comments[indexPath.row].date
        cell.commentLabel.text = comments[indexPath.row].comment
        cell.backgroundColor = .clear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.fBaseRef = Database.database().reference()
        
        self.addSubview(tableView)
        self.addSubview(commentField)
        self.insertSubview(blur, aboveSubview: tableView)
        self.addSubview(postButton)
        self.bringSubview(toFront: postButton)
        postButton.setNeedsDisplay()

        self.setupTableView()
        self.setupCommentField()
        self.setupBlur()
        self.setupPostButton()
        //self.populateView()
    }


    public func populateView() {
        guard let albumID = self.parent?.selectedAlbumId else {return}
        fBaseRef?.child("Comments").observeSingleEvent(of: .value, with: { (snapshot) in
            for comment in snapshot.children {
                guard let commentSnap = comment as? DataSnapshot else {return}
                if commentSnap.hasChild(albumID) {
                    guard
                        let username = commentSnap.childSnapshot(forPath: "Username").value as? String,
                        let date = commentSnap.childSnapshot(forPath: "Date").value as? String,
                        let comment = commentSnap.childSnapshot(forPath: "Comment").value as? String else { return }
                    self.comments.append(Comment(username: username, date: date, comment: comment))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }
    
    private func setupPostButton() {
        postButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        postButton.topAnchor.constraint(equalTo: commentField.topAnchor).isActive = true
        postButton.heightAnchor.constraint(equalTo: self.commentField.heightAnchor).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupBlur() {
        blur.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        blur.topAnchor.constraint(equalTo: commentField.topAnchor, constant: -10).isActive = true
        blur.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupCommentField() {
        commentField.delegate = self
        commentField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        commentField.rightAnchor.constraint(equalTo: postButton.leftAnchor, constant: -16).isActive = true
        commentField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        commentField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentField.resignFirstResponder()
        return true
    }
    
    private func setupTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        
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
