//
//  TDLoginVC.swift
//  Qismet
//
//  Created by Lalit on 10/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import PermissionScope


class TDLoginVC: UIViewController, UIScrollViewDelegate
{

    @IBOutlet weak var btnSign: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var multiPscope = PermissionScope()
    var snapchatSwipeContainer = SnapContainerViewController()
    
//    let permissionAssistant = SPRequestPermissionAssistant.modules.dialog.interactive.create(with: [.Camera, .PhotoLibrary, .Notification ])
    
    var pagingView: TimedPageControlView!
    var currentPage = 0
    var currentActivePage = 0
    var currentActivePageProgress: Float = 0.0
    var timer: Timer?

    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.isStatusBarHidden = true
        self.pageControl.currentPage = 0
        
        multiPscope.show({ finished, results in
            print("got results \(results)")
        }, cancelled: { (results) -> Void in
            print("thing was cancelled")
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupDefaults() {
        
        let imageArray = ["placeholder7", "placeholder1", "placeholder7"]
        var count:CGFloat = 0.0
        for item in imageArray {
            
            let image = UIImage(named: item)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: self.view.frame.size.width*count, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            imageView.isUserInteractionEnabled = true
            imageView.autoresizesSubviews = true
            count += 1;
            let gradientView = UIView()
            gradientView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            gradientView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
            imageView.addSubview(gradientView)
            self.scrollView.addSubview(imageView)
        }
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width*3, height: self.view.frame.size.height)
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.delegate = self
        self.btnSign.isExclusiveTouch = true
        self.privacyPolicyBtn.isExclusiveTouch = true
        
        self.pageControl.transform = CGAffineTransform(rotationAngle:CGFloat(M_PI_2))
        
        // Set up paging control view
        pagingView = TimedPageControlView(collapsedWidth: 10, total: 3)
        pagingView.translatesAutoresizingMaskIntoConstraints = false
        pagingView.alpha = 1.0
        pagingView.isUserInteractionEnabled = false
        view.addSubview(pagingView!);
        
        
        // Layout our paging control view
        let top = NSLayoutConstraint(item: pagingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -160)
        let center = NSLayoutConstraint(item: pagingView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let h = NSLayoutConstraint(item: pagingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        let w = NSLayoutConstraint(item: pagingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        NSLayoutConstraint.activate([top, center, w, h])
        
        // Simulate timer
        startTimer()
        
        
        multiPscope.addPermission(CameraPermission(), message: "We use this to send you\r\nspam and love notes")
        multiPscope.addPermission(NotificationsPermission(notificationCategories: nil), message: "We use this to track\r\nwhere you live")
        multiPscope.addPermission(LocationWhileInUsePermission(), message: "We use this to track\r\nwhere you live")
        
        if UserDefaults.standard.bool(forKey: KisRemember) == true {
            
            if (UserDefaults.standard.bool(forKey: KUserDefaultsProfilecompleted) == true){
                logInfo("Profile Completed")
            }
            else{
                logInfo("Profile Not Completed")
            }
            
            //            let snapchatSwipeContainer = SnapchatSwipeContainerViewController()
            //            snapchatSwipeContainer.leftVC = imageVC
            //            snapchatSwipeContainer.middleVC = profileVC
            //            snapchatSwipeContainer.rightVC = journalVC
            
            let profileVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCameraVC") as! TDCameraVC
            let journalVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDViewJournalVC") as! TDViewJournalVC
            let imageVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomImageVC") as! TDCustomImageVC
//            let activityVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDConnectionContainerVC") as! TDConnectionContainerVC
//            let discoverVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverContainerVC") as! TDDiscoverContainerVC
            
            let connectTab = TDConnectionTabBarController()
            let discoverTab = TDDiscoverTabBarController()
            

            
            
            snapchatSwipeContainer = SnapContainerViewController.containerViewWith(imageVC,
                                                                                   middleVC: profileVC,
                                                                                   rightVC: journalVC,
                                                                                   topVC: discoverTab,
                                                                                   bottomVC: connectTab)
            
            self.navigationController?.isNavigationBarHidden = true
            UIApplication.shared.isStatusBarHidden = true
            self.navigationController?.pushViewController(snapchatSwipeContainer, animated: false)
            
            multiPscope.show({ finished, results in
                print("got results \(results)")
            }, cancelled: { (results) -> Void in
                print("thing was cancelled")
            })
            
        }else{
            // permissionAssistant.present(on: self)
        }
    }
    
    func startTimer() {
        currentActivePageProgress = 0
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateProgressForCurrentPage), userInfo: nil, repeats: true)
    }
    
    func updateProgressForCurrentPage() {
        currentActivePageProgress = Float(currentActivePageProgress) + 0.01
        
        setProgressOfPage(tag: currentActivePage + 1, progress: Float(currentActivePageProgress))
        if (currentActivePageProgress >= 1) {
            timer?.invalidate()
            scrollToPage(page: currentActivePage + 1, animated: true)
        }
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        if (page > 5 || page < 0) {
            return;
        }
        
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.scrollView.scrollRectToVisible(frame, animated: animated)
    }
    
    func setProgressOfPage(tag: Int, progress: Float) {
        if let pageProgress = pagingView.viewWithTag(tag) as? TimedPageButton {
            pageProgress.completePercentage = progress
        }
    }
    
    //MARK:- UIScrollView Delegate Methods
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
//        
//        let indexCurrentPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
//        self.pageControl.currentPage = Int(indexCurrentPage);
//        
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pagingView.scrollDirection = .none
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetX: CGFloat = scrollView.contentOffset.x;
        let pageWidth: CGFloat = scrollView.frame.size.width;
        
        let fractionalPage: CGFloat = currentOffsetX / pageWidth
        
        if(scrollView.panGestureRecognizer.translation(in: scrollView.superview).x > 0) {
            pagingView.scrollDirection = .left
        } else {
            pagingView.scrollDirection = .right
        }
        
        if(!fractionalPage.isNaN) {
            currentPage = lround(Double(fractionalPage))
            pagingView.changePage(fractionalPage: min(fractionalPage, 4))
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentActivePage = currentPage
        startTimer()
    }
    
    //MARK:- UIButton Actions
    
    @IBAction func privacyBtnAction(_ sender: UIButton) {
        
        let termsVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDTermsAndPrivacyVC") as! TDTermsAndPrivacyVC
        termsVC.isFromLogin = true
        termsVC.navigationBarTitle = "Terms & Privacy Policy"
        self.present(termsVC, animated: true, completion: nil)
    }
    
    @IBAction func pageControlAction(_ sender: UIPageControl) {
        
        scrollView.setContentOffset(CGPoint(x: (sender.currentPage * Int(self.view.frame.size.height)), y:0), animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        FacebookManager.facebookManager.getFacebookInfoWithCompletionHandler(self) { (result, token, error) in
            if token.length>0{
                
                self.makeWebApiLoginWithInfo(token: token)
            }
        }
//        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "TDUserProfileVC") as! TDUserProfileVC
//        self.navigationController?.pushViewController(profileVC, animated: true)

    }
    
    
    //MARK:- Web Service Method For Login
    
    func makeWebApiLoginWithInfo(token:String){
        
        let dictParam = NSMutableDictionary();
        dictParam[Kpush_token] = "kjhsdlkfhdslfsdflsdh"
        dictParam[Kdevice_type] = 1
        dictParam[Kfb_token] = token
        UserDefaults.standard.set(token, forKey: Kfb_token)
        ServiceHelper.callAPIWithParameters(dictParam, method: .post, apiName: kFacebook) { (result, error) in
            
            let response = result as! NSMutableDictionary
            UserDefaults.standard.set(true, forKey: KisRemember)
            UserDefaults.standard.set(response.object(forKey:KAuthToken), forKey: KAuthToken)
            UserDefaults.standard.set(response.object(forKey:Kprofilecompleted), forKey: KUserDefaultsProfilecompleted)
            UserDefaults.standard.set(response.object(forKey:KuserId), forKey: KuserId)
            UserDefaults.standard.synchronize()
            
            if (UserDefaults.standard.bool(forKey: KUserDefaultsProfilecompleted) == true){
                logInfo("Profile Completed")
            }
            else{
                logInfo("Profile Not Completed")
            }
            
            //            let snapchatSwipeContainer = SnapchatSwipeContainerViewController()
            //            snapchatSwipeContainer.leftVC = imageVC
            //            snapchatSwipeContainer.middleVC = profileVC
            //            snapchatSwipeContainer.rightVC = journalVC

            
            let profileVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCameraVC") as! TDCameraVC
            let journalVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDViewJournalVC") as! TDViewJournalVC
            let imageVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomImageVC") as! TDCustomImageVC
//            let activityVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDConnectionContainerVC") as! TDConnectionContainerVC
//            let discoverVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDDiscoverContainerVC") as! TDDiscoverContainerVC
            
            let connectTab = TDConnectionTabBarController()
            let discoverTab = TDDiscoverTabBarController()
            
            self.snapchatSwipeContainer = SnapContainerViewController.containerViewWith(connectTab,
                                                                                   middleVC: profileVC,
                                                                                   rightVC: discoverTab,
                                                                                   topVC: imageVC,
                                                                                   bottomVC: journalVC)
            
            self.navigationController?.isNavigationBarHidden = true
            UIApplication.shared.isStatusBarHidden = true
            self.navigationController?.pushViewController(self.snapchatSwipeContainer, animated: false)
        }
    }
    

    //MARK:- Memory Warning Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
