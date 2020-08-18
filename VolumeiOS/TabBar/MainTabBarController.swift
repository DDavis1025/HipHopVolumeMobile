//
//  MainTabBarController.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 8/18/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = UIColor.lightGray
        setUpTabBar()
        
    }
    
    func setUpTabBar() {
        let homeFeedController = UINavigationController(rootViewController: HomeViewController())
        let homeImage = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal)
        homeFeedController.tabBarItem.image = homeImage
        let homeImageFill = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)
        homeFeedController.tabBarItem.selectedImage = homeImageFill
        
        let notificationVC = UINavigationController(rootViewController: NotificationVC())
        let notificationImage = UIImage(systemName: "bell")?.withRenderingMode(.alwaysOriginal)
        notificationVC.tabBarItem.image = notificationImage
        let notificationImageFill = UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysOriginal)
        notificationVC.tabBarItem.selectedImage = notificationImageFill
        
        let profileVC = UINavigationController(rootViewController: ProfileVC())
        let profileImage = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.image = profileImage
        let profileImageFill = UIImage(systemName: "person.circle.fill")?.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.selectedImage = profileImageFill
        
        viewControllers = [homeFeedController, notificationVC, profileVC]
    }
    
    
    func setupToolBar() {
        
    }
}
