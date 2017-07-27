//
//  TDActivityContainerVC.swift
//  Qismet
//
//  Created by Suresh patel on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import CarbonKit

class TDActivityContainerVC: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    @IBOutlet var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        // Do any additional setup after loading the view.
    }
    
    func setupDefaults(){
        
        let items = ["MESSAGES", "MATCHES", "HISTORY"]        
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: containerView)
        carbonTabSwipeNavigation.setTabBarHeight(30)
        carbonTabSwipeNavigation.setIndicatorHeight(0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.indicatorPosition = .bottom
        carbonTabSwipeNavigation.setNormalColor(UIColor.lightGray, font: kAppFontDemiBoldWithSize(12))
        carbonTabSwipeNavigation.setSelectedColor(RGBA(255, g: 0, b: 88, a: 1.0), font: kAppFontDemiBoldWithSize(12))
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(kWindowWidth()/3, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(kWindowWidth()/3, forSegmentAt: 1)
        carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(kWindowWidth()/3, forSegmentAt: 2)
        carbonTabSwipeNavigation.currentTabIndex = 2
        
        let notificationName = Notification.Name("ActivityWillAppear")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: notificationName, object: nil)
    }
    
    func refreshScreen(){
        UIApplication.shared.isStatusBarHidden = false
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.scrollView.contentOffset.y = 0.0
        loginVC.snapchatSwipeContainer.scrollView.contentSize.height = kWindowHeight()
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        // return viewController at index
        
        switch index {
        case 0:
            let activityVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDActivityVC") as! TDActivityVC
            activityVC.activityType = ActivityType.impressions
            return activityVC
        case 1:
            let activityVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDActivityVC") as! TDActivityVC
            activityVC.activityType = ActivityType.matches
            return activityVC
        default:
            let activityVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDActivityVC") as! TDActivityVC
            activityVC.activityType = ActivityType.history
            return activityVC
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
