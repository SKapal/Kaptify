//
//  AlbumViewCollectionViewCell.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-22.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class AlbumViewCollectionViewCell: UICollectionViewCell {
    var selectedAlbumImage = UIImage()
    var selectedAlbumTitle = String()
    var selectedAlbumArtist = String()
    var selectedAlbumReleaseDate = String()
    var selectedAlbumURL = String()
    var selectedAlbumId = String()
    
    var fBaseRef: DatabaseReference?
    
    let albumImage: UIImageView = {
        let albumImg = UIImageView()
        
        albumImg.translatesAutoresizingMaskIntoConstraints = false
        albumImg.contentMode = .scaleAspectFit
        return albumImg
    }()
    
    let albumView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let albumTitleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        let font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        title.font = font
        title.textColor = .white
        title.numberOfLines = 2
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    let albumArtistLabel: UILabel = {
        let artist = UILabel()
        artist.textAlignment = .center
        let font = UIFont(name: "HelveticaNeue-Light", size: 17)
        artist.font = font
        artist.textColor = .white
        artist.translatesAutoresizingMaskIntoConstraints = false
        return artist
    }()
    
    let albumReleaseDateLabel: UILabel = {
        let release = UILabel()
        release.textAlignment = .center
        let font = UIFont(name: "HelveticaNeue-Light", size: 14)
        release.font = font
        release.textColor = .white
        release.translatesAutoresizingMaskIntoConstraints = false
        return release
    }()
    
    lazy var addButton: UIButton = {
        let add = UIButton(type: .custom)
        let addImage = UIImage(named: "addButton")
        let addImageView = UIImageView(image: addImage)
        addImageView.contentMode = .scaleAspectFill
        add.setImage(addImageView.image, for: .normal)
        add.translatesAutoresizingMaskIntoConstraints = false
        add.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        return add
    }()
    
    var numberOfAddsLabel: UILabel = {
        let adds = UILabel()
        adds.textAlignment = .center
        let font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        adds.font = font
        adds.textColor = .white
        adds.translatesAutoresizingMaskIntoConstraints = false
        return adds
    }()
    
    var addStack = UIStackView()
    
    lazy var openButton: UIButton = {
        let open = UIButton(type: .custom)
        let openImage = UIImage(named: "openButton")
        let openImageView = UIImageView(image: openImage)
        openImageView.contentMode = .scaleAspectFill
        open.setImage(openImageView.image, for: .normal)
        open.translatesAutoresizingMaskIntoConstraints = false
        open.addTarget(self, action: #selector(handleOpenButton), for: .touchUpInside)
        return open
    }()
    
    @objc fileprivate func handleOpenButton() {
        UIApplication.shared.open(URL(string: self.selectedAlbumURL)!, options: [:]) { (status) in }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        self.updateAddButtonAndLabelWithUserData()
        fBaseRef = Database.database().reference()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        
        self.addSubview(albumView)
        self.addSubview(albumImage)
        
        self.addSubview(albumTitleLabel)
        self.addSubview(albumArtistLabel)
        self.addSubview(albumReleaseDateLabel)
        
        
        self.addSubview(openButton)
        
        
        addStack = UIStackView(arrangedSubviews: [addButton, numberOfAddsLabel])
        addStack.axis = .vertical
        addStack.translatesAutoresizingMaskIntoConstraints = false
        addStack.spacing = 1
        
        self.addSubview(addStack)
        
        self.setupAlbumView()
        self.setupAlbumImage()
        self.setupAlbumTitleLabel()
        self.setupAddStack()
        self.setupAlbumArtistLabel()
        self.setupAlbumReleaseDateLabel()
        self.setupOpenButton()
        
    }
    
    fileprivate func setupAlbumView() {
        albumView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        albumView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        albumView.widthAnchor.constraint(equalToConstant: 204).isActive = true
        albumView.heightAnchor.constraint(equalToConstant: 204).isActive = true
    }
    
    fileprivate func setupAlbumImage() {
        albumImage.centerXAnchor.constraint(equalTo: albumView.centerXAnchor).isActive = true
        albumImage.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func setupAlbumTitleLabel() {
        albumTitleLabel.leftAnchor.constraint(equalTo: albumView.leftAnchor).isActive = true
        albumTitleLabel.rightAnchor.constraint(equalTo: albumView.rightAnchor).isActive = true
        albumTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: albumView.bottomAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setupAlbumArtistLabel() {
        albumArtistLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        albumArtistLabel.topAnchor.constraint(greaterThanOrEqualTo: albumTitleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setupAlbumReleaseDateLabel() {
        albumReleaseDateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        albumReleaseDateLabel.bottomAnchor.constraint(equalTo: addStack.bottomAnchor).isActive = true
        albumReleaseDateLabel.rightAnchor.constraint(lessThanOrEqualTo: addStack.leftAnchor).isActive = true
    }
    
    fileprivate func setupAddStack() {
        addStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        addStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
    }
    
    fileprivate func setupOpenButton() {
        openButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        openButton.topAnchor.constraint(greaterThanOrEqualTo: albumArtistLabel.bottomAnchor, constant: 25).isActive = true
    }
    
    
    
    // Update button image helper
    fileprivate func changeButtonImage(named imageName: String) {
        DispatchQueue.main.async {
            let addImageView = UIImageView(image: UIImage(named: imageName))
            addImageView.contentMode = .scaleAspectFill
            self.addButton.setImage(addImageView.image, for: .normal)
        }
    }
    
    func addRemoveAlbumToUser(album: [String: AnyObject]) {
        if let uid = Auth.auth().currentUser?.uid {
            fBaseRef?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.childSnapshot(forPath: "addedAlbums").hasChild(self.selectedAlbumId) {
                    self.fBaseRef?.child("Users").child(uid).child("addedAlbums").child(self.selectedAlbumId).setValue(album)
                } else {
                    self.fBaseRef?.child("Users").child(uid).child("addedAlbums").child(self.selectedAlbumId).removeValue()
                }
            })
        }
    }
    
    @objc fileprivate func handleAddButton() {
        
        /*
         * - Add to user profile (Album fb object: title, image URL, artist, release date, id, URL)
         * - Increment/Decrement adds counter
         * - Replace "addButton" with "minusButton" and vice versa
         */
        print("add")
        fBaseRef?.child("Albums").child(selectedAlbumId).runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var album = currentData.value as? [String: AnyObject], let uid = Auth.auth().currentUser?.uid {
                var adds: Dictionary<String, Bool>
                adds = album["adds"] as? [String: Bool] ?? [:]
                var addsCount = album["addsCount"] as? Int ?? 0
                
                if let _ = adds[uid] {
                    addsCount -= 1
                    adds.removeValue(forKey: uid)
                    self.changeButtonImage(named: "addButton")
                } else {
                    addsCount += 1
                    adds[uid] = true
                    self.changeButtonImage(named: "minusButton")
                }
                album["addsCount"] = addsCount as AnyObject?
                album["adds"] = adds as AnyObject?
                self.addRemoveAlbumToUser(album: album)
                currentData.value = album
                
                // update UI
                DispatchQueue.main.async {
                    self.numberOfAddsLabel.text = addsCount > 1 || addsCount == 0 ? "\(addsCount) stars" : "\(addsCount) star"
                    
                }
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, comitted, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // Load Add Button UI
    func updateAddButtonAndLabelWithUserData() {
        fBaseRef?.child("Albums").child(selectedAlbumId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let uid = Auth.auth().currentUser?.uid {
                if snapshot.childSnapshot(forPath: "adds").hasChild(uid){
                    self.changeButtonImage(named: "minusButton")
                    DispatchQueue.main.async {
                        if let addsCount = snapshot.childSnapshot(forPath: "addsCount").value {
                            self.numberOfAddsLabel.text = addsCount as! Int > 1 || addsCount as! Int == 0 ? "\(addsCount) stars" : "\(addsCount) star"
                        } else {
                            self.numberOfAddsLabel.text = "0 stars"
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.numberOfAddsLabel.text = "0 stars"
                    }
                }
            }
        })
    }
    
}

