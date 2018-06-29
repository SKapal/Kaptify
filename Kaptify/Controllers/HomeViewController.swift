//
//  HomeViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-24.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UITableViewController {
    
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
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleOptions), with: nil, afterDelay: 0)
            handleOptions()
        }
        
        setupNavBar()
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
        let title = UIImage(named: "Logo_text")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = imageView
    }
}
