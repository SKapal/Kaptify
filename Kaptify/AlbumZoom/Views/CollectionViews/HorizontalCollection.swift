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

protocol ScrollMenuDelegate {
    func scrollToMenuIndex(menuIndex: Int)
}


class HorizontalCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ScrollMenuDelegate {
    
    var selectedAlbumImage: UIImage?
    var selectedAlbumTitle: String?
    var selectedAlbumArtist: String?
    var selectedAlbumReleaseDate: String?
    var selectedAlbumURL: String?
    var selectedAlbumId:String?
    
    var menuBar: MenuBar?

    
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
        collectionView.register(AlbumViewCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CommentsTableViewCollectionViewCell.self, forCellWithReuseIdentifier: cellId2)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AlbumViewCollectionViewCell
            

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! CommentsTableViewCollectionViewCell
            cell.parent = self
            cell.populateView();
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.menuBar?.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    private func setupCollectionView() {
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let index = IndexPath(item: menuIndex, section: 0)
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrollIndex = IndexPath(item: Int(targetContentOffset.pointee.x / self.frame.width), section: 0)
        
        menuBar?.collectionView.selectItem(at: scrollIndex, animated: true, scrollPosition: .centeredHorizontally)
    }
}


