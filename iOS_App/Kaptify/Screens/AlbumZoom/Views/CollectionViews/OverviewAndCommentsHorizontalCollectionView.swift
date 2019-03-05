//
//  OverviewAndCommentsHorizontalCollectionView.swift
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

final class OverviewAndCommentsHorizontalCollectionView: UIView {
    
    var selectedAlbumImage: UIImage!
    var selectedAlbumTitle: String!
    var selectedAlbumArtist: String!
    var selectedAlbumReleaseDate: String!
    var selectedAlbumURL: String!
    var selectedAlbumId:String!
    
    var menuBar: MenuBar?

    private let cellId1 = "cellIdentifier1"
    private let cellId2 = "cellIdentifier2"
    
    private lazy var collectionView: UICollectionView = {
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
        addSubview(collectionView)
        collectionView.register(AlbumViewCollectionViewCell.self, forCellWithReuseIdentifier: cellId1)
        collectionView.register(CommentsTableViewCollectionViewCell.self, forCellWithReuseIdentifier: cellId2)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar?.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }
    
    private func setupCollectionView() {
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrollIndex = IndexPath(item: Int(targetContentOffset.pointee.x / frame.width), section: 0)

        menuBar?.collectionView.selectItem(at: scrollIndex, animated: true, scrollPosition: .centeredHorizontally)
    }
}

extension OverviewAndCommentsHorizontalCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId1, for: indexPath) as! AlbumViewCollectionViewCell

            cell.albumTitleLabel.text = selectedAlbumTitle
            cell.albumImage.image = selectedAlbumImage
            cell.albumArtistLabel.text = selectedAlbumArtist
            cell.albumReleaseDateLabel.text = "Released on \(selectedAlbumReleaseDate ?? "Date")"
            
            DispatchQueue.main.async {
                cell.selectedAlbumId = self.selectedAlbumId
                cell.selectedAlbumURL = self.selectedAlbumURL
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
}

extension OverviewAndCommentsHorizontalCollectionView: ScrollMenuDelegate {
    func scrollToMenuIndex(menuIndex: Int) {
        let index = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
}
