//
//  ViewController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-24.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(r: 51, b: 51, g: 51)
        
        // add leftButton
        let leftButton = UIBarButtonItem(title: "Login", style: .plain, target: self, action: Selector(("handleLogoutButton")))
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItem = leftButton
    }
    func handleLogoutButton() {
        
    }
}

extension UIColor {
    convenience init(r: CGFloat, b: CGFloat, g: CGFloat) {
        self.init(red: r/255, green: b/255, blue: g/255, alpha: 1)
    }
}
