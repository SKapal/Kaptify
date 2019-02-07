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
        self.tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "profileCellId")
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let user = Auth.auth().currentUser
        if let user = user {
            self.navigationItem.title = "\(user.displayName ?? "User")s Activity"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellId", for: indexPath) as! ProfileTableViewCell
        
        cell.activityLabel.text = "Starred"
        cell.albumImageView.image = UIImage(named: "mbdtf")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
