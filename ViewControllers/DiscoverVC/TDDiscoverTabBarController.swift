//
//  TDDiscoverTabBarController.swift
//  Qismet
//
//  Created by Lalit on 06/04/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDDiscoverTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let discoverVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverVC") as! TDDiscoverVC
        discoverVC.discoverType = .newest
        let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "discoverIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "discoverIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        discoverVC.tabBarItem = tabOneBarItem
        tabOneBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
//        let featureVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverVC") as! TDDiscoverVC
//        featureVC.discoverType = .featured
//        let tabTwoBarItem = UITabBarItem(title: "", image: UIImage(named: "starIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "starIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
//        featureVC.tabBarItem = tabTwoBarItem
//        tabTwoBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        let distanceVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverVC") as! TDDiscoverVC
        distanceVC.discoverType = .dist
        let tabthreeBarItem = UITabBarItem(title: "", image: UIImage(named: "distanceIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "distanceIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        distanceVC.tabBarItem = tabthreeBarItem
        tabthreeBarItem.imageInsets = UIEdgeInsetsMake(6, -25, -6, 25);
        
        let exploreVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDExploreVC") as! TDExploreVC
        let tabFourBarItem = UITabBarItem(title: "", image: UIImage(named: "exploreIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "exploreIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        exploreVC.tabBarItem = tabFourBarItem
        tabFourBarItem.imageInsets = UIEdgeInsetsMake(6, 25, -6, -25);
        
        let momentsVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDMomentsVC") as! TDMomentsVC
        momentsVC.momentType = MomentsType.recent
        let tabfiveBarItem = UITabBarItem(title: "", image: UIImage(named: "momentIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "momentIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        momentsVC.tabBarItem = tabfiveBarItem
        tabfiveBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

        
        self.viewControllers = [discoverVC, distanceVC, exploreVC,momentsVC]
        
        let captureBtn = UIButton(frame: CGRect(x: (kWindowWidth()-50)/2, y: kWindowHeight()-75, width: 50, height: 50))
        captureBtn.layer.cornerRadius = 25
        captureBtn.clipsToBounds = true
        captureBtn.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        captureBtn.layer.borderWidth = 2.0
        captureBtn.addTarget(self, action: #selector(tapOnCapture), for: .touchUpInside)
        self.view.addSubview(captureBtn)

        
        let notificationName = Notification.Name("DiscoverWillAppear")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: notificationName, object: nil)

    }
    
    func refreshScreen(){
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.scrollView.contentOffset.y = 0.0
        loginVC.snapchatSwipeContainer.scrollView.contentSize.height = 1.0

    }
    
    func tapOnCapture(){
        
        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.middleVertScrollVc.scrollView.setContentOffset(CGPoint(x: 0.0, y: kWindowHeight()), animated: true)

//        let notificationName = Notification.Name("CameraWillAppear")
//        NotificationCenter.default.post(name: notificationName, object: nil)
//        
//        perform(#selector(setContentOffset), with: nil, afterDelay: 1.0)

    }
    
    func setContentOffset(){
        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.scrollView.setContentOffset(CGPoint(x: kWindowWidth(), y: 0.0), animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.backgroundColor = UIColor.white
//        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
//        self.tabBar.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
//        self.tabBar.layer.shadowOpacity = 2.0
//        self.tabBar.layer.shadowRadius = 2.0
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
