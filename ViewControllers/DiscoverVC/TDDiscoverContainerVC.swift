//
//  TDDiscoverContainerVC.swift
//  Qismet
//
//  Created by Suresh patel on 20/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import CarbonKit

class TDDiscoverContainerVC: UIViewController, CarbonTabSwipeNavigationDelegate {

    @IBOutlet var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        // Do any additional setup after loading the view.
    }
    

    func setupDefaults(){
        
        let items = ["FEATURED", "NEWEST", "DIST - \(settingPreferences.strRadius) Mi"]
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
        carbonTabSwipeNavigation.currentTabIndex = 1
        
      //  UIApplication.shared.isStatusBarHidden = false
        let notificationName = Notification.Name("DiscoverWillAppear")
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
            let discoverVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverVC") as! TDDiscoverVC
            discoverVC.discoverType = DiscoverType.featured
            return discoverVC
        case 1:
            let discoverVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverVC") as! TDDiscoverVC
            discoverVC.discoverType = DiscoverType.newest
            return discoverVC
        default:
            let discoverVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverVC") as! TDDiscoverVC
            discoverVC.discoverType = DiscoverType.dist
            return discoverVC
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton){
     
        let searchVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDSearchVC") as! TDSearchVC
        self.present(searchVC, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
