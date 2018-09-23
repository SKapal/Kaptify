//
//  CustomTabBarController.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-06-28.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Point to HomeViewController as root
        let homeController = UINavigationController(rootViewController: HomeViewController())
        homeController.tabBarItem.image = UIImageView(image: UIImage(named: "home_unselected")).image
        
        // Setup for ProfileViewController as root
        let profileController = UINavigationController(rootViewController: ProfileViewController())
        profileController.tabBarItem.image = UIImageView(image: UIImage(named: "profile_unselected")).image
        
        // Setup for SettingsViewController as root
        
        
        setupNavBarAppearance()
        setupTabBarAppearance()
        
        // Updated for current functionality:
        viewControllers = [homeController, /*setupTabBarItems(imageName: "search_unselected"), setupTabBarItems(imageName: "plus_unselected"),*/ profileController, setupTabBarItems(imageName: "settings_unselected")]
        
    }
    
    private func setupTabBarItems(imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImageView(image: UIImage(named: imageName)).image
        return navController
    }
    
    private func setupTabBarAppearance() {
        self.tabBar.barTintColor = UIColor(r: 28, b: 27, g: 27)
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(r: 255, b: 157, g: 41)
        self.tabBar.unselectedItemTintColor = .white
    }
    
    private func setupNavBarAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(r: 28, b: 27, g: 27)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }

}
