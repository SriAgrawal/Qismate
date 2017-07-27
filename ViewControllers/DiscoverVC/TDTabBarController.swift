//
//  TDTabBarController.swift
//  Qismet
//
//  Created by Suresh patel on 20/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let discoverVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverContainerVC") as! TDDiscoverContainerVC
        let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "discoverIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "discoverIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        discoverVC.tabBarItem = tabOneBarItem
        tabOneBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        let exploreVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDExploreVC") as! TDExploreVC
        let tabTwoBarItem = UITabBarItem(title: "", image: UIImage(named: "exploreIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "exploreIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        exploreVC.tabBarItem = tabTwoBarItem
        tabTwoBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

        let momentsVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDMomentsContainerVC") as! TDMomentsContainerVC
        let tabthreeBarItem = UITabBarItem(title: "", image: UIImage(named: "photoIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "photoIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        momentsVC.tabBarItem = tabthreeBarItem
        tabthreeBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

        
        let activityVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDActivityContainerVC") as! TDActivityContainerVC
        let tabFourBarItem = UITabBarItem(title: "", image: UIImage(named: "activityIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "activityIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        activityVC.tabBarItem = tabFourBarItem
        tabFourBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);


        self.viewControllers = [discoverVC, exploreVC, momentsVC, activityVC]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
        
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.tabBar.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        self.tabBar.layer.shadowOpacity = 2.0
        self.tabBar.layer.shadowRadius = 2.0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
