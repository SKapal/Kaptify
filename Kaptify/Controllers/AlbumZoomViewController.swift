//
//  AlbumZoomViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-19.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class AlbumZoomViewController: UIViewController {
    
    // initial touch position
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    var selectedAlbumImage = UIImage()
    var selectedAlbumTitle = String()
    var selectedAlbumArtist = String()
    var selectedAlbumReleaseDate = String()
    var selectedAlbumURL = String()
    
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
    
    @objc func handleOpenButton() {
        UIApplication.shared.open(URL(string: self.selectedAlbumURL)!, options: [:]) { (status) in }
    }
    
    @objc func handleAddButton() {
        // TODO
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  .clear
        self.view.isOpaque = false
        
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
    
    func setupView() {
        self.view.addSubview(albumBackgroundImage)
        self.view.addSubview(albumView)
        self.view.addSubview(albumImage)
        
        self.view.insertSubview(blur, aboveSubview: albumBackgroundImage)

        self.view.addSubview(albumTitleLabel)
        self.view.addSubview(albumArtistLabel)
        self.view.addSubview(albumReleaseDateLabel)
        self.view.addSubview(slideImage)
        self.view.addSubview(addButton)
        self.view.addSubview(openButton)
        
        self.setupBlur()
        self.setupAlbumBackgroundImage()
        self.setupAlbumView()
        self.setupAlbumImage()
        self.setupAlbumTitleLabel()
        self.setupAlbumArtistLabel()
        self.setupAlbumReleaseDateLabel()
        self.setupSlideImage()
        self.setupAddButton()
        self.setupOpenButton()
    }
    
    //MARK: Setup view constraints & pass data to UI
    func setupAlbumBackgroundImage() {
        albumBackgroundImage.image = selectedAlbumImage
        albumBackgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        albumBackgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        albumBackgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        albumBackgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.view.frame.height/2).isActive = true
        albumBackgroundImage.heightAnchor.constraint(equalToConstant: self.view.frame.height * 4/10).isActive = true
    }
    
    func setupBlur() {
        blur.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func setupAlbumView() {
        albumView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        albumView.bottomAnchor.constraint(equalTo: albumBackgroundImage.bottomAnchor, constant: 50).isActive = true
        albumView.widthAnchor.constraint(equalToConstant: 204).isActive = true
        albumView.heightAnchor.constraint(equalToConstant: 204).isActive = true
    }
    
    func setupAlbumImage() {
        albumImage.image = selectedAlbumImage
        albumImage.centerXAnchor.constraint(equalTo: albumView.centerXAnchor).isActive = true
        albumImage.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupAlbumTitleLabel() {
        albumTitleLabel.text = self.selectedAlbumTitle
        albumTitleLabel.leftAnchor.constraint(equalTo: albumView.leftAnchor).isActive = true
        albumTitleLabel.rightAnchor.constraint(equalTo: albumView.rightAnchor).isActive = true
        albumTitleLabel.topAnchor.constraint(greaterThanOrEqualTo: albumView.bottomAnchor, constant: 13).isActive = true
    }
    
    func setupAlbumArtistLabel() {
        albumArtistLabel.text = self.selectedAlbumArtist
        albumArtistLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        albumArtistLabel.topAnchor.constraint(greaterThanOrEqualTo: albumTitleLabel.bottomAnchor, constant: 13).isActive = true
    }
    
    func setupAlbumReleaseDateLabel() {
        albumReleaseDateLabel.text = "Released on \(selectedAlbumReleaseDate)"
        albumReleaseDateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        albumReleaseDateLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        albumReleaseDateLabel.rightAnchor.constraint(lessThanOrEqualTo: addButton.leftAnchor).isActive = true
    }
    
    func setupSlideImage() {
        slideImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        slideImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func setupAddButton() {
        addButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        addButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
    }
    
    func setupOpenButton() {
        openButton.topAnchor.constraint(lessThanOrEqualTo: albumArtistLabel.bottomAnchor, constant: 30).isActive = true
        openButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        openButton.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor).isActive = true
    }
    
}

//MARK: Gesture
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
}
