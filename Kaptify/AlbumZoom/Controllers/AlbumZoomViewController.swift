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

class AlbumZoomViewController: UIViewController{

    
    // initial touch position
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    var selectedAlbumImage = UIImage()
    var selectedAlbumTitle = String()
    var selectedAlbumArtist = String()
    var selectedAlbumReleaseDate = String()
    var selectedAlbumURL = String()
    var selectedAlbumId = String()
    
    var fBaseRef: DatabaseReference?
    
    lazy var menuBar: MenuBar = {
        let menu = MenuBar()
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()
    
    lazy var menuCollection: HorizontalCollection = {
        let collection = HorizontalCollection(frame: .zero)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //MARK: View property setup
    let albumBackgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleAspectFit
        return bg
    }()
    
    let slideImage: UIImageView = {
        let slide = UIImageView()
        let img = UIImage(named: "slideView")
        slide.image = img
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.contentMode = .scaleAspectFill
        return slide
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
        self.view.addSubview(albumBackgroundImage)
        
        self.view.insertSubview(blur, aboveSubview: albumBackgroundImage)
        self.view.addSubview(menuBar)

        self.view.addSubview(slideImage)
        self.view.addSubview(menuCollection)
        

        self.setupMenuBar()
        self.setupBlur()
        
        self.setupAlbumBackgroundImage()
        self.setupSlideImage()
        self.setupMenuCollection()
    }
    
    //MARK: Setup view constraints & pass data to UI
    fileprivate func setupMenuCollection() {
        menuCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        menuCollection.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        menuCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        menuCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.menuCollection.selectedAlbumArtist = selectedAlbumArtist
        self.menuCollection.selectedAlbumTitle = selectedAlbumTitle
        self.menuCollection.selectedAlbumImage = selectedAlbumImage
        self.menuCollection.selectedAlbumId = selectedAlbumId
        self.menuCollection.selectedAlbumURL = selectedAlbumURL
        self.menuCollection.selectedAlbumReleaseDate = selectedAlbumReleaseDate
        
    }

    
    fileprivate func setupMenuBar() {
        menuBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: self.slideImage.topAnchor).isActive = true
        menuBar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
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

    fileprivate func setupSlideImage() {
        slideImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
        slideImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        slideImage.bottomAnchor.constraint(lessThanOrEqualTo: slideImage.topAnchor, constant: 5)
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
}
