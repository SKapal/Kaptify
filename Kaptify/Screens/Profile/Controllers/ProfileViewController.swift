//
//  ProfileViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-12.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor(r: 51, b: 51, g: 51)
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationItem.title = Auth.auth().currentUser?.displayName
    }
    
    
}
