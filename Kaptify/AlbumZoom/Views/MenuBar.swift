//
//  MenuBar.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-08-09.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellIdentifier"
    var scrollDelegate: ScrollMenuDelegate?
    let menuTitles = ["Album", "Comments"]
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let horizontalBarView: UIView = {
        let bar = UIView()
        bar.backgroundColor = .white
        bar.layer.shadowColor = UIColor.black.cgColor
        bar.layer.shadowRadius = 2.0
        bar.layer.shadowOpacity = 0.2
        bar.layer.shadowOffset = CGSize(width: 2, height: 2)
        bar.layer.masksToBounds = false
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(collectionView)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        self.setupCollectionView()
        DispatchQueue.main.async {
            self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredVertically)
        }
        setupHorizontalBar()
        
    }
    

    
    private func setupHorizontalBar() {
        
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/8).isActive = true
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.titleLabel.text = self.menuTitles[indexPath.item]
        cell.titleLabel.textColor = .white
        let font = UIFont(name: "HelveticaNeue-Light", size: 16)
        cell.titleLabel.font = font
        //cell.isSelected = indexPath.item == 0 ? true : false
       // cell.isHighlighted = indexPath.item == 0 ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            scrollDelegate?.scrollToMenuIndex(menuIndex: indexPath.item)
        } else {
            scrollDelegate?.scrollToMenuIndex(menuIndex: indexPath.item)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/2, height: frame.height)
    }
    
    fileprivate func setupCollectionView() {
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MenuCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Album"
        let blackColor: UIColor = .black
        label.layer.shadowColor = blackColor.cgColor
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 0.2
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectedFont = UIFont(name: "HelveticaNeue-Bold", size: 16)
    let unselectedFont = UIFont(name: "HelveticaNeue-Light", size: 16)
    
    override var isHighlighted: Bool {
        didSet {
            titleLabel.font = isHighlighted ? selectedFont : unselectedFont
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? selectedFont : unselectedFont
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        backgroundColor = .clear
        
        self.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

