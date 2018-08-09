//
//  HomeViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-24.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol NetworkRequestDelegate {
    func requestDataAndPopulateView(jsonString: String)
}

class HomeViewController: UIViewController, NetworkRequestDelegate {
    
    let dataFetcher = DataFetcher()
    
    let cellIdentifier = "cellIdentifier"
    
    var albums = [Album]()
    var fbaseRef: DatabaseReference?
    
    //MARK: Home View UI Elements
    let albumCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 150, height: 195)
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
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
    
    lazy var dropButton: UIButton = {
        let drop = UIButton(type: .system)
        let dropImage = UIImage(named: "DropDownButton")
        let dropIV = UIImageView(image: dropImage)
        dropIV.contentMode = .scaleAspectFill
        drop.setImage(dropIV.image, for: .normal)
        drop.translatesAutoresizingMaskIntoConstraints = false
        drop.isUserInteractionEnabled = true
        drop.addTarget(self, action: #selector(handleDrop), for: .touchUpInside)
        return drop
    }()
    
    let dropView: DropDownView = {
        let view = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var isOpen:Bool = false
    @objc func handleDrop() {
        if !isOpen {
            isOpen = true
            animateDropDown(toHeight: 87, with: 1)
        } else {
            isOpen = false
            animateDropDown(toHeight: 0, with: -1)
        }
    }
    
    func animateDropDown(toHeight height: CGFloat, with multiplier: CGFloat) {
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = height
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            if multiplier == 1 {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y = self.dropView.center.y  + multiplier * (self.dropView.frame.height/2)
            } else {
                self.dropView.center.y = self.dropView.center.y  + multiplier * (self.dropView.frame.height/2)
                self.dropView.layoutIfNeeded()
            }
            
        }, completion: nil)
    }

    //MARK: Activity Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        
        checkIfValidUser()
        setupNavBar()
        
        fbaseRef = Database.database().reference()
        
        albumCollection.delegate = self
        albumCollection.dataSource = self
        dropView.dropDelegate = self
        
        setupUIElements()
        requestDataAndPopulateView(jsonString: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json")
    }
    
    public func requestDataAndPopulateView(jsonString: String) {
        dataFetcher.obtainData(jsonString: jsonString) { (result, err) in
            guard let payload = result else {return}
            self.albums = payload
            DispatchQueue.main.async {
                self.albumCollection.reloadData()
            }
            //update firebase albums
            self.updateFirebase(Albums: self.albums)
        }
        // if drop down is open, close:
        if(height.constant > 0) {
            self.animateDropDown(toHeight: 0, with: -1)
            self.isOpen = false
        }
    }
    
    func updateFirebase(Albums: [Album]) {
        for album in albums {
            guard let id = album.id, let name = album.name, let artist = album.artistName, let link = album.url, let artURL = album.artworkUrl100, let releaseDate = album.releaseDate else { return }
            fbaseRef?.child("Albums").observeSingleEvent(of: .value, with: { (snapshot) in
                if !snapshot.hasChild(id) {
                    print("Adding new data...")
                    self.fbaseRef?.child("Albums").child(id).child("name").setValue(name)
                    self.fbaseRef?.child("Albums").child(id).child("artist").setValue(artist)
                    self.fbaseRef?.child("Albums").child(id).child("link").setValue(link)
                    self.fbaseRef?.child("Albums").child(id).child("releaseDate").setValue(releaseDate)
                    self.fbaseRef?.child("Albums").child(id).child("artURL").setValue(artURL)
                }
            })
        }
    }
    
    func setupUIElements() {
        self.view.addSubview(collectionBg)
        self.view.addSubview(albumCollection)
        self.view.addSubview(dropView)
        self.view.bringSubview(toFront: dropView)
        
        setupCollectionBg()
        setupAlbumCollection()
        setupDropView()
    }
    var height = NSLayoutConstraint()
    
    //MARK: Setup view constraints
    func setupDropView() {
        dropView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        dropView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        dropView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    func setupAlbumCollection() {
        //load cell from nib
        self.albumCollection.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func setupCollectionBg() {
        collectionBg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionBg.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        collectionBg.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionBg.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        collectionBg.heightAnchor.constraint(equalToConstant: 229).isActive = true
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
        // add leftButton and rightButton
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: optionsButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dropButton)
        // add title 
        let title = UIImage(named: "Logo_text")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = imageView
    }
}

//MARK: Extension with Collection View protocol methods
extension HomeViewController:  UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! AlbumCollectionViewCell

        // Round album image
        cell.albumImage.layer.masksToBounds = true
        cell.albumImage.layer.cornerRadius = 7
        cell.albumImage.alpha = 0

        // Load cell data with backing array data
        cell.albumLabel.text = self.albums[indexPath.item].name
        cell.albumLabel.textColor = .white

        cell.artistLabel.text = self.albums[indexPath.item].artistName
        cell.artistLabel.textColor = .white
        
        guard let artwork = self.albums[indexPath.item].artworkUrl100 else { return UICollectionViewCell() }
        if let imageURL = URL(string: artwork) {
            // Load image data on background thread
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    // Update UI on main thread
                    DispatchQueue.main.async {
                        cell.albumImage.image = image
                        UIView.animate(withDuration: 1, animations: {
                            cell.albumImage.alpha = 1
                        })
                    }
                }
                
            }
        }

        cell.backgroundColor = .clear
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        albumCollection.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    // Display album zoom view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumZoom = AlbumZoomViewController()
        albumZoom.modalPresentationStyle = .overFullScreen
        albumZoom.selectedAlbumTitle = albums[indexPath.item].name!
        albumZoom.selectedAlbumArtist = albums[indexPath.item].artistName!
        albumZoom.selectedAlbumReleaseDate = albums[indexPath.item].releaseDate!
        albumZoom.selectedAlbumURL = albums[indexPath.item].url!
        albumZoom.selectedAlbumId = albums[indexPath.item].id!
        
        if let artwork = self.albums[indexPath.item].artworkUrl100, let imageURL = URL(string: artwork) {
            // Load image data on background thread
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    // Update UI on main thread
                    DispatchQueue.main.async {
                        albumZoom.selectedAlbumImage = image!
                       self.present(albumZoom, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
}









