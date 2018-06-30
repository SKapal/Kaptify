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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        
        checkIfValidUser()
        setupNavBar()
        
        self.view.addSubview(collectionBg)
        setupCollectionBg()

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
