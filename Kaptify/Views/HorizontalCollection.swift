//
//  HorizontalCollection.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-20.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class HorizontalCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var selectedAlbumImage: UIImage?
    var selectedAlbumTitle: String?
    var selectedAlbumArtist: String?
    var selectedAlbumReleaseDate: String?
    var selectedAlbumURL: String?
    var selectedAlbumId:String?
    
    let cellId = "cellIdentifier"
    let cellId2 =  "cellIdentifier2"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(collectionView)
        collectionView.register(AlbumViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CommentsViewCell.self, forCellWithReuseIdentifier: cellId2)
        self.setupCollectionView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AlbumViewCell
            

            cell.albumTitleLabel.text = self.selectedAlbumTitle!
            cell.albumImage.image = self.selectedAlbumImage!
            cell.albumArtistLabel.text = self.selectedAlbumArtist!
            cell.albumReleaseDateLabel.text = "Released on \(self.selectedAlbumReleaseDate!)"
            
            DispatchQueue.main.async {
                cell.selectedAlbumId = self.selectedAlbumId!
                cell.selectedAlbumURL = self.selectedAlbumURL!
                cell.updateAddButtonAndLabelWithUserData()
            }
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! CommentsViewCell
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    fileprivate func setupCollectionView() {
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    

}

class CommentsViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    let cellIdentifier = "commentCellIdentifier"
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CommentTableViewCell
        
        cell.usernameLabel.text = "Splashbruh"
        cell.dateLabel.text = "Today"
        cell.commentLabel.text = "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been is simply dummy text of the is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been is simply dummy text of the is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been is simply dummy text of the is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been is simply dummy text of the"
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

class AlbumViewCell: UICollectionViewCell {
    
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
//        albumImage.image = selectedAlbumImage
        albumImage.centerXAnchor.constraint(equalTo: albumView.centerXAnchor).isActive = true
        albumImage.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func setupAlbumTitleLabel() {
//        albumTitleLabel.text = self.selectedAlbumTitle
        albumTitleLabel.leftAnchor.constraint(equalTo: albumView.leftAnchor).isActive = true
        albumTitleLabel.rightAnchor.constraint(equalTo: albumView.rightAnchor).isActive = true
        albumTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: albumView.bottomAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setupAlbumArtistLabel() {
//        albumArtistLabel.text = self.selectedAlbumArtist
        albumArtistLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        albumArtistLabel.topAnchor.constraint(greaterThanOrEqualTo: albumTitleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setupAlbumReleaseDateLabel() {
//        albumReleaseDateLabel.text = "Released on \(selectedAlbumReleaseDate)"
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
        openButton.topAnchor.constraint(greaterThanOrEqualTo: albumArtistLabel.bottomAnchor, constant: 50).isActive = true
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
