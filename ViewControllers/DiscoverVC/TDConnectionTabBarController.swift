//
//  TDConnectionTabBarController.swift
//  Qismet
//
//  Created by Lalit on 03/04/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDConnectionTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDActivityVC") as! TDActivityVC
        messageVC.activityType = .impressions
        let tabOneBarItem = UITabBarItem(title: "", image: UIImage(named: "messageIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "messageIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        messageVC.tabBarItem = tabOneBarItem
        tabOneBarItem.imageInsets = UIEdgeInsetsMake(6, 25, -6, -25);
        
        let matchVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDActivityVC") as! TDActivityVC
         matchVC.activityType = .matches
        let tabTwoBarItem = UITabBarItem(title: "", image: UIImage(named: "heartGreyIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "heartRedIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        matchVC.tabBarItem = tabTwoBarItem
        tabTwoBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        let historyVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDActivityVC") as! TDActivityVC
        historyVC.activityType = .history
        let tabthreeBarItem = UITabBarItem(title: "", image: UIImage(named: "historyGreyIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "historyRedIcon")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        historyVC.tabBarItem = tabthreeBarItem
        tabthreeBarItem.imageInsets = UIEdgeInsetsMake(6, -25, -6, 25);
        
        let searchVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDSearchVC") as! TDSearchVC
        let tabFourBarItem = UITabBarItem(title: "", image: UIImage(named: "searchIconGrey")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "searchIconRed")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        searchVC.tabBarItem = tabFourBarItem
        tabFourBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
        
        self.viewControllers = [searchVC,historyVC,messageVC,matchVC]
        
        let captureBtn = UIButton(frame: CGRect(x: (kWindowWidth()-50)/2, y: kWindowHeight()-75, width: 50, height: 50))
        captureBtn.layer.cornerRadius = 25
        captureBtn.clipsToBounds = true
        captureBtn.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        captureBtn.layer.borderWidth = 2.0
        captureBtn.addTarget(self, action: #selector(tapOnCapture), for: .touchUpInside)
        self.view.addSubview(captureBtn)
                
        let notificationName = Notification.Name("ActivityWillAppear")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: notificationName, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBar.backgroundColor = UIColor.white
//        self.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
//        self.tabBar.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
//        self.tabBar.layer.shadowOpacity = 2.0
//        self.tabBar.layer.shadowRadius = 2.0

    }
    
    func tapOnCapture(){
        
//        let notificationName = Notification.Name("CameraWillAppear")
//        NotificationCenter.default.post(name: notificationName, object: nil)
//        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.middleVertScrollVc.scrollView.setContentOffset(CGPoint(x: 0.0, y: kWindowHeight()), animated: true)
    }
    func refreshScreen(){
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.scrollView.contentOffset.y = 0.0
        loginVC.snapchatSwipeContainer.scrollView.contentSize.height = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
