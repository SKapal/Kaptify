//
//  ProfileViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-12.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor(r: 51, b: 51, g: 51)
        
        // add leftButton
        self.navigationItem.leftItemsSupplementBackButton = true
        // add title
        let title = UIImage(named: "Logo_text")
        let imageView = UIImageView(image: title)
        imageView.contentMode = .scaleAspectFill
        self.navigationItem.titleView = imageView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
