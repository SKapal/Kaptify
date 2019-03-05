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

final class AlbumZoomViewController: UIViewController{
    
    // initial touch position
    private var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    var selectedAlbumImage = UIImage()
    var selectedAlbumTitle = String()
    var selectedAlbumArtist = String()
    var selectedAlbumReleaseDate = String()
    var selectedAlbumURL = String()
    var selectedAlbumId = String()
    
    private var fBaseRef: DatabaseReference?
    
    private lazy var menuBar: MenuBar = {
        let menu = MenuBar()
        menu.translatesAutoresizingMaskIntoConstraints = false
        return menu
    }()
    
    private lazy var menuCollection: OverviewAndCommentsHorizontalCollectionView = {
        let collection = OverviewAndCommentsHorizontalCollectionView(frame: .zero)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    //MARK: View property setup
    private let albumBackgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.contentMode = .scaleAspectFit
        return bg
    }()
    
    private let slideImage: UIImageView = {
        let slide = UIImageView()
        let img = UIImage(named: "slideView")
        slide.image = img
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.contentMode = .scaleAspectFill
        return slide
    }()
    
    private let blur: UIVisualEffectView = {
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurredView = UIVisualEffectView(effect: blur)
        blurredView.translatesAutoresizingMaskIntoConstraints = false
        return blurredView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  .clear
        self.view.isOpaque = false
        
        fBaseRef = Database.database().reference()
        self.setupView()
        
        let slide = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(gesture:)))
        view.addGestureRecognizer(slide)
        
        // sub to notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
        
    }

    private func setupView() {
        view.addSubview(albumBackgroundImage)
        
        view.insertSubview(blur, aboveSubview: albumBackgroundImage)
        view.addSubview(menuBar)

        view.addSubview(slideImage)
        view.addSubview(menuCollection)

        setupMenuBar()
        setupBlur()
        
        setupAlbumBackgroundImage()
        setupSlideImage()
        setupMenuCollection()
    }
    
    //MARK: Setup view constraints & pass data to UI
    private func setupMenuCollection() {
        menuCollection.menuBar = menuBar
        
        menuCollection.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuCollection.topAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        menuCollection.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        menuCollection.selectedAlbumArtist = selectedAlbumArtist
        menuCollection.selectedAlbumTitle = selectedAlbumTitle
        menuCollection.selectedAlbumImage = selectedAlbumImage
        menuCollection.selectedAlbumId = selectedAlbumId
        menuCollection.selectedAlbumURL = selectedAlbumURL
        menuCollection.selectedAlbumReleaseDate = selectedAlbumReleaseDate
    }

    private func setupMenuBar() {
        menuBar.scrollDelegate = menuCollection
        menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: slideImage.topAnchor).isActive = true
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupAlbumBackgroundImage() {
        albumBackgroundImage.image = selectedAlbumImage
        albumBackgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        albumBackgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        albumBackgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        albumBackgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -self.view.frame.height/2).isActive = true
        albumBackgroundImage.heightAnchor.constraint(equalToConstant: view.frame.height * 4/9).isActive = true
    }
    
    private func setupBlur() {
        blur.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blur.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        blur.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        blur.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupSlideImage() {
        slideImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 45).isActive = true
        slideImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slideImage.bottomAnchor.constraint(lessThanOrEqualTo: slideImage.topAnchor, constant: 5)
    }
}

//MARK: Methods and Helpers
extension AlbumZoomViewController {
    @objc func panGestureRecognizerHandler(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: view?.window)
        
        if gesture.state == UIGestureRecognizer.State.began {
            initialTouchPoint = touchPoint
        } else if gesture.state == UIGestureRecognizer.State.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: view.frame.size.width, height: view.frame.size.height)
            }
        } else if gesture.state == UIGestureRecognizer.State.ended || gesture.state == UIGestureRecognizer.State.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
}
