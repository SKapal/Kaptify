//
//  AlbumZoomViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-19.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AlbumZoomViewController: UIViewController {
    
    // initial touch position
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    var selectedAlbumImage = UIImage()
    var selectedAlbumTitle = String()
    var selectedAlbumArtist = String()
    var selectedAlbumReleaseDate = String()
    var selectedAlbumURL = String()
    var selectedAlbumId = String()
    
    var fBaseRef: DatabaseReference?
    
    //MARK: View property setup
    let albumBackgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleAspectFit
        return bg
    }()
    
    let albumImage: UIImageView = {
        let albumImg = UIImageView()

        albumImg.translatesAutoresizingMaskIntoConstraints = false
        albumImg.contentMode = .scaleAspectFit
        return albumImg
    }()
    
    let slideImage: UIImageView = {
        let slide = UIImageView()
        let img = UIImage(named: "slideView")
        slide.image = img
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.contentMode = .scaleAspectFill
        return slide
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
    
    lazy var commentsButton: UIButton = {
        let comment = UIButton(type: .custom)
        let commentImage = UIImage(named: "Comments")
        let commentImageView = UIImageView(image: commentImage)
        commentImageView.contentMode = .scaleAspectFill
        comment.setImage(commentImageView.image, for: .normal)
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.addTarget(self, action: #selector(handleCommentsButton), for: .touchUpInside)
        return comment
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  .clear
        self.view.isOpaque = false
        
        fBaseRef = Database.database().reference()
        self.setupView()
        
        let slide = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(gesture:)))
        view.addGestureRecognizer(slide)
    }
    
    let blur: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurredView = UIVisualEffectView(effect: blur)
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        return blurredView
    }()
    
    fileprivate func setupView() {
        updateAddButtonAndLabelWithUserData()
        self.view.addSubview(albumBackgroundImage)
        self.view.addSubview(albumView)
        self.view.addSubview(albumImage)
        
        self.view.insertSubview(blur, aboveSubview: albumBackgroundImage)

        self.view.addSubview(albumTitleLabel)
        self.view.addSubview(albumArtistLabel)
        self.view.addSubview(albumReleaseDateLabel)
        self.view.addSubview(slideImage)
        self.view.addSubview(openButton)
        self.view.addSubview(commentsButton)
        
        addStack = UIStackView(arrangedSubviews: [addButton, numberOfAddsLabel])
        addStack.axis = .vertical
        addStack.translatesAutoresizingMaskIntoConstraints = false
        addStack.spacing = 1

        self.view.addSubview(addStack)
        
        self.setupBlur()
        self.setupAlbumBackgroundImage()
        self.setupAlbumView()
        self.setupAlbumImage()
        self.setupAlbumTitleLabel()
        self.setupAlbumArtistLabel()
        self.setupAlbumReleaseDateLabel()
        self.setupSlideImage()
        self.setupOpenButton()
        self.setupAddStack()
        self.setupCommentsButton()
    }
    
    //MARK: Setup view constraints & pass data to UI
    fileprivate func setupCommentsButton() {
        commentsButton.rightAnchor.constraint(equalTo: addButton.rightAnchor).isActive = true
        commentsButton.topAnchor.constraint(equalTo: slideImage.bottomAnchor).isActive = true
        commentsButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        commentsButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    fileprivate func setupAddStack() {

        addStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        addStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
    }
    
    fileprivate func setupNumberOfAddsLabel() {
        numberOfAddsLabel.rightAnchor.constraint(equalTo: addButton.rightAnchor).isActive = true
        numberOfAddsLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10).isActive = true
    }
    
    fileprivate func setupAlbumBackgroundImage() {
        albumBackgroundImage.image = selectedAlbumImage
        albumBackgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        albumBackgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        albumBackgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        albumBackgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.view.frame.height/2).isActive = true
        albumBackgroundImage.heightAnchor.constraint(equalToConstant: self.view.frame.height * 4/9).isActive = true
    }
    
    fileprivate func setupBlur() {
        blur.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    fileprivate func setupAlbumView() {
        albumView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        albumView.topAnchor.constraint(equalTo: slideImage.bottomAnchor, constant: self.view.frame.height/10).isActive = true
        albumView.widthAnchor.constraint(equalToConstant: 204).isActive = true
        albumView.heightAnchor.constraint(equalToConstant: 204).isActive = true
    }
    
    fileprivate func setupAlbumImage() {
        albumImage.image = selectedAlbumImage
        albumImage.centerXAnchor.constraint(equalTo: albumView.centerXAnchor).isActive = true
        albumImage.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    fileprivate func setupAlbumTitleLabel() {
        albumTitleLabel.text = self.selectedAlbumTitle
        albumTitleLabel.leftAnchor.constraint(equalTo: albumView.leftAnchor).isActive = true
        albumTitleLabel.rightAnchor.constraint(equalTo: albumView.rightAnchor).isActive = true
        albumTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: albumView.bottomAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setupAlbumArtistLabel() {
        albumArtistLabel.text = self.selectedAlbumArtist
        albumArtistLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        albumArtistLabel.topAnchor.constraint(greaterThanOrEqualTo: albumTitleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    fileprivate func setupAlbumReleaseDateLabel() {
        albumReleaseDateLabel.text = "Released on \(selectedAlbumReleaseDate)"
        albumReleaseDateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        albumReleaseDateLabel.bottomAnchor.constraint(equalTo: addStack.bottomAnchor).isActive = true
        albumReleaseDateLabel.rightAnchor.constraint(lessThanOrEqualTo: addStack.leftAnchor).isActive = true
    }
    
    fileprivate func setupSlideImage() {
        slideImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        slideImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupAddButton() {
        addButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        addButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    fileprivate func setupOpenButton() {
        openButton.topAnchor.constraint(lessThanOrEqualTo: albumArtistLabel.bottomAnchor, constant: 30).isActive = true
        openButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
}

//MARK: Methods and Helpers
extension AlbumZoomViewController {
    
    @objc func panGestureRecognizerHandler(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view?.window)
        
        if gesture.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if gesture.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if gesture.state == UIGestureRecognizerState.ended || gesture.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    // Load Add Button UI
    fileprivate func updateAddButtonAndLabelWithUserData() {
        fBaseRef?.child("Albums").child(selectedAlbumId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let uid = Auth.auth().currentUser?.uid {
                if snapshot.childSnapshot(forPath: "adds").hasChild(uid){
                    self.changeButtonImage(named: "minusButton")
                    DispatchQueue.main.async {
                        if let addsCount = snapshot.childSnapshot(forPath: "addsCount").value {
                            self.numberOfAddsLabel.text = "\(addsCount)"
                        } else {
                            self.numberOfAddsLabel.text = "0"
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.numberOfAddsLabel.text = "0"
                    }
                }
            }
        })
    }
    
    // Update button image helper
    fileprivate func changeButtonImage(named imageName: String) {
        DispatchQueue.main.async {
            let addImageView = UIImageView(image: UIImage(named: imageName))
            addImageView.contentMode = .scaleAspectFill
            self.addButton.setImage(addImageView.image, for: .normal)
        }
    }
    
    fileprivate func addRemoveAlbumToUser(album: [String: AnyObject]) {
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
    
    //MARK: Button pressed handler Selectors:
    @objc fileprivate func handleOpenButton() {
        UIApplication.shared.open(URL(string: self.selectedAlbumURL)!, options: [:]) { (status) in }
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
                    self.numberOfAddsLabel.text = String(addsCount)
                    
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
    
    @objc fileprivate func handleCommentsButton() {
        // TODO: present new view w/ comments
        
        
    }
}
