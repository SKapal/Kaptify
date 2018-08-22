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


