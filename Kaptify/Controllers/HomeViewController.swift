//
//  HomeViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-24.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    let dataFetcher = DataFetcher()
    
    let cellIdentifier = "cellIdentifier"
    
    //Temporary Test Data
    let objects = ["Yeezus", "Lost & Found", "Scorpion", "Lol", "hi", "MBDTF", "Flower Boy", "Nirvana", "Beasty boys", "For the only time ever I will die"]
    let names = ["Kanye West", "Jorja Smith", "Drake", "meme", "sup", "Kanye West", "Tyler the Creator", "Nirvana", "Beasty boys", "Sahil"]
    
    var albums = [Album]()
    
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
        
//        self.dataFetcher.obtainData()
        //Networking (Remove later)
        let jsonString = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/explicit.json"
        guard let url = URL(string: jsonString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check error
            // check response (200)
            
            guard let data = data else { return }
            
            do {
                let obj = try JSONDecoder().decode(object.self, from: data)
                guard let results = obj.feed?.results else { return }
                self.albums = results
                DispatchQueue.main.async {
                    self.albumCollection.reloadData()
                }
            } catch let jsonError {
                print("Error with json", jsonError)
            }
            
        }.resume()
    }
    
    func setupUIElements() {
        self.view.addSubview(collectionBg)
        self.view.addSubview(albumCollection)
        
        setupCollectionBg()
        setupAlbumCollection()
    }
    
    //MARK: Setup view constraints
    func setupAlbumCollection() {
        //load cell from nib
        self.albumCollection.register(UINib(nibName: "AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        //self.albumCollection.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

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
        
        
        // cell.albumImage.image = UIImage(named: "mbdtf")
        cell.albumImage.layer.masksToBounds = true
        cell.albumImage.layer.cornerRadius = 7
        
        cell.albumLabel.text = self.albums[indexPath.item].name //self.objects[indexPath.item]
        cell.albumLabel.textColor = .white
        
        cell.artistLabel.text = self.albums[indexPath.item].artistName //self.names[indexPath.item]
        cell.artistLabel.textColor = .white
        
        guard let artwork = self.albums[indexPath.item].artworkUrl100 else { return UICollectionViewCell() }
        if let imageURL = URL(string: artwork) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.albumImage.image = image
                    }
                }
                
            }
        }
        
        
        
        cell.backgroundColor = .clear //UIColor(r: 51, b: 51, g: 51)
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        albumCollection.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
}
