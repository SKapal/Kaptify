//
//  HomeViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-24.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellIdentifier = "cellIdentifier"
    let objects = ["Yeezus", "Lost & Found", "Scorpion", "Lol", "hi"]
    
    //MARK: Collection View protocol methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AlbumCollectionViewCell
        cell.albumLabel?.text = self.objects[indexPath.item]
        print(self.objects[indexPath.item])
        print("Cell label: \(cell.albumLabel?.text)")
        cell.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        albumCollection.frame = CGRect(x: 0, y: recentReleaseLabel.frame.origin.y + recentReleaseLabel.frame.height + 20, width: view.frame.width, height: 185)
    }
    
    //MARK: Home View UI Elements
    let albumCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 98, height: 130)
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear /* TEMP */
        return collection
    }()
    
    let recentReleaseLabel: UILabel = {
        let rLabel = UILabel()
        rLabel.text = "Recent Releases"
        rLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        rLabel.textColor = .white
        rLabel.translatesAutoresizingMaskIntoConstraints = false
        return rLabel
    }()
    
    let collectionBg: UIImageView = {
        let imV = UIImageView()
        let im = UIImage(named: "collection_bg")
        imV.image = im
        imV.translatesAutoresizingMaskIntoConstraints = false
        imV.contentMode = .scaleAspectFill
        return imV
    }()
    
    lazy var optionsButton: UIButton = {
        let options = UIButton(type: .system)
        let optionsImage = UIImage(named: "options_btn")
        let optionsImageView = UIImageView(image: optionsImage)
        optionsImageView.contentMode = .scaleAspectFill
        options.setImage(optionsImageView.image, for: .normal)
        options.translatesAutoresizingMaskIntoConstraints = false
        options.addTarget(self, action: #selector(handleOptions), for: .touchUpInside)
        return options
    }()

    //MARK: Activity Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        
        checkIfValidUser()
        setupNavBar()
        
        albumCollection.delegate = self
        albumCollection.dataSource = self
        
        setupUIElements()
    }
    
    func setupUIElements() {
        self.view.addSubview(collectionBg)
        self.view.addSubview(recentReleaseLabel)
        self.view.addSubview(albumCollection)
        
        setupCollectionBg()
        setupAlbumCollection()
        setupRecentReleaseLabel()
    }
    
    //MARK: Setup view constraints
    func setupAlbumCollection() {
        //load cell from nib
        self.albumCollection.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.albumCollection.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        // Setup collection constraints
        albumCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        albumCollection.topAnchor.constraint(equalTo: recentReleaseLabel.bottomAnchor, constant: 20).isActive = true
        albumCollection.heightAnchor.constraint(equalToConstant: 200).isActive = true
        albumCollection.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func setupCollectionBg() {
        collectionBg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionBg.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        collectionBg.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionBg.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        collectionBg.heightAnchor.constraint(equalToConstant: 229).isActive = true
    }
    
    func setupRecentReleaseLabel() {
        recentReleaseLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        recentReleaseLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        recentReleaseLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func checkIfValidUser() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleOptions), with: nil, afterDelay: 0)
            handleOptions()
        }
    }
    
    @objc func handleOptions() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutErr {
            print(logoutErr)
        }
        
        let registerController = RegisterViewController()
        present(registerController, animated: true, completion: nil)
    }
    
    func setupNavBar() {
        // add leftButton
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: optionsButton)
        // add title 
        let title = UIImage(named: "Logo_text")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = imageView
    }
}
