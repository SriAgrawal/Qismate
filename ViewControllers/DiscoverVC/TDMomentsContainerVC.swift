//
//  TDMomentsContainerVC.swift
//  Qismet
//
//  Created by Suresh patel on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import CarbonKit

class TDMomentsContainerVC: UIViewController, CarbonTabSwipeNavigationDelegate {

    @IBOutlet var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        // Do any additional setup after loading the view.
    }
    
    func setupDefaults(){
        
        let items = ["FEATURED", "RECENT", "DIST - \(settingPreferences.strRadius) Mi"]
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
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        // return viewController at index
        
        switch index {
        case 0:
            let momentVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDMomentsVC") as! TDMomentsVC
            momentVC.momentType = MomentsType.featured
            return momentVC
        case 1:
            let momentVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDMomentsVC") as! TDMomentsVC
            momentVC.momentType = MomentsType.recent
            return momentVC
        default:
            let momentVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDMomentsVC") as! TDMomentsVC
            momentVC.momentType = MomentsType.dist
            return momentVC
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
