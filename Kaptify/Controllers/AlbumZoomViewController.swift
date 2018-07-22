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
    

    
    let albumBackgroundImage: UIImageView = {
        let bg = UIImageView()
        let img = UIImage(named: "mbdtf")
        bg.image = img
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleAspectFill
        return bg
    }()
    
    let albumImage: UIImageView = {
        let albumImg = UIImageView()
        let img = UIImage(named: "mbdtf")
        albumImg.image = img
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

    let albumReleaseDate = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor(r: 51, b: 51, g: 51)
        
        self.setupView()
        
        let slide = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(gesture:)))
        view.addGestureRecognizer(slide)
    }
    
    func setupView() {
        self.view.addSubview(albumBackgroundImage)
        self.view.addSubview(albumView)
        self.view.addSubview(albumImage)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurredView = UIVisualEffectView(effect: blur)
        blurredView.frame = albumBackgroundImage.bounds
        blurredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        albumBackgroundImage.addSubview(blurredView)
        
        self.view.addSubview(albumTitleLabel)
        self.view.addSubview(albumArtistLabel)
        self.view.addSubview(albumReleaseDate)
        
        self.setupAlbumBackgroundImage()
        self.setupAlbumView()
        self.setupAlbumImage()
        self.setupAlbumTitleLabel()
        setupAlbumArtistLabel()
    }
    
    func setupAlbumBackgroundImage() {
        albumBackgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        albumBackgroundImage.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        albumBackgroundImage.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        albumBackgroundImage.heightAnchor.constraint(equalToConstant: self.view.frame.height * 6/11).isActive = true
    }
    
    func setupAlbumView() {
        albumView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        albumView.bottomAnchor.constraint(equalTo: albumBackgroundImage.bottomAnchor, constant: 40).isActive = true
        albumView.widthAnchor.constraint(equalToConstant: 204).isActive = true
        albumView.heightAnchor.constraint(equalToConstant: 204).isActive = true
    }
    
    func setupAlbumImage() {
        albumImage.centerXAnchor.constraint(equalTo: albumView.centerXAnchor).isActive = true
        albumImage.centerYAnchor.constraint(equalTo: albumView.centerYAnchor).isActive = true
        albumImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupAlbumTitleLabel() {
        albumTitleLabel.text = "My Beautiful Dark Twisted Fantasy"
        albumTitleLabel.leftAnchor.constraint(equalTo: albumView.leftAnchor).isActive = true
        albumTitleLabel.rightAnchor.constraint(equalTo: albumView.rightAnchor).isActive = true
        albumTitleLabel.topAnchor.constraint(equalTo: albumView.bottomAnchor, constant: 13).isActive = true
    }
    
    func setupAlbumArtistLabel() {
        albumArtistLabel.text = "Kanye West"
        albumArtistLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        albumArtistLabel.topAnchor.constraint(equalTo: albumTitleLabel.bottomAnchor, constant: 13).isActive = true
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
