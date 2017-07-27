//
//  TDHomeVC.swift
//  Qismet
//
//  Created by Lalit on 16/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit



class TDHomeVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    var objProfile = TDUserList()
    var rootViewController: TDSettingVC?
    var camViewController : SwiftyCamViewController!
    
    var settingPreferences = TDUserPreferences()
    var currentUserProfile: TDUserList!
    var countryList = NSMutableArray()

    var isFirstLoad = true
    var homeVC : TDCameraVC!
    var disableInteractivePlayerTransitioning = false
    var presentInteractor: MiniToLargeViewInteractive!
    var dismissInteractor: MiniToLargeViewInteractive!
    
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?


    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            isFirstLoad = false
            disableInteractivePlayerTransitioning = true
            self.present(homeVC, animated: false) { [unowned self] in
                self.disableInteractivePlayerTransitioning = false
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults() {
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        self.makeWebApiGetProfileWithInfo()
       // self.createCameraView()
        prepareView()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)

    }
    
    func prepareView() {
        
        
        homeVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCameraVC") as! TDCameraVC
        
        homeVC.rootViewController = self
        homeVC.transitioningDelegate = self
        homeVC.modalPresentationStyle = .fullScreen
        
        presentInteractor = MiniToLargeViewInteractive()
        presentInteractor.attachToViewController(self, withView: UIView(), presentViewController: homeVC)
        dismissInteractor = MiniToLargeViewInteractive()
        dismissInteractor.attachToViewController(homeVC, withView: homeVC.view, presentViewController: nil)
    }

    func createCameraView(){
        
        self.camViewController = SwiftyCamViewController(frame: CGRect(x: 0, y: 0, width: kWindowWidth()/2, height: kWindowWidth()/2))
        camViewController.allowBackgroundAudio = true
    }
    
    func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: 0,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
           if velocity.y <= -250{
                UIView.animate(withDuration: 0.0, animations: {
                    self.view.center = self.originalPosition!
                    self.disableInteractivePlayerTransitioning = true
                    self.present(self.homeVC, animated: false) { [unowned self] in
                        self.disableInteractivePlayerTransitioning = false
                    }

                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }


    
    //MARK:- UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeProfileCell", for: indexPath) as! HomeProfileCell
            cell.tileImage.image = UIImage(named: "placeholder7")
            cell.descriptionLbl.text = "DISCOVER"
            cell.topBtn.addTarget(self, action: #selector(tapOnTopPortion), for:. touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
            cell.tileImageView.isHidden = false
            cell.blurImageView.isHidden = false

            switch indexPath.row {
            case 1:
                cell.tileImageView.sd_setImage(with: self.objProfile.profilePicUrl, placeholderImage: UIImage(named: "placeholder1"), options: .refreshCached) //UIImage(named: "placeholder1")
                cell.descriptionLbl.text = "PROFILE"
                cell.countLbl.isHidden = true
                cell.notifyLbl.isHidden = true
            case 2:
                cell.tileImageView.sd_setImage(with: self.objProfile.lastJournalPic, placeholderImage: UIImage(named: "placeholder1"), options: .refreshCached) //UIImage(named: "placeholder1")
                cell.descriptionLbl.text = "STORY"
                cell.countLbl.text = self.objProfile.journalCount
                if settingPreferences.isPrivateJournal {
                    cell.notifyLbl.text = "PRIVATE"
                }else{
                     cell.notifyLbl.text = "PUBLIC"
                }
                cell.countLbl.isHidden = false
                cell.notifyLbl.isHidden = false
            case 3:
                cell.tileImageView.image = UIImage(named: "placeholder7")
                cell.descriptionLbl.text = "MESSAGES"
                cell.countLbl.isHidden = false
                cell.countLbl.text = "0"
                cell.notifyLbl.isHidden = true
            case 4:
                cell.tileImageView.image = UIImage(named: "placeholder7")
                //cell.blurImageView.isHidden = true

                cell.descriptionLbl.text = "EXPLORE"
                cell.countLbl.isHidden = true
              //  cell.tileImageView.isHidden = true
                cell.notifyLbl.isHidden = true
//                cell.contentView.backgroundColor = UIColor.red
//                if let cameraView = self.camViewController {
//                    cameraView.view.isUserInteractionEnabled = false
//                    cell.contentView.addSubview(cameraView.view)
//                    cell.contentView.sendSubview(toBack: cameraView.view)
//                }
            default:
                break
            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.row == 0 {
            return CGSize(width: kWindowWidth(), height: 292)
        }else{
            return CGSize(width: kWindowWidth()/2, height: kWindowWidth()/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        switch indexPath.item {
        case 0:

            let tabbar = TDTabBarController()
            self.present(tabbar, animated: true, completion: nil)
            break
            
        case 1:
            
            let profileVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDUserProfileVC") as! TDUserProfileVC
            self.present(profileVC, animated: true, completion: nil)
            
            break
            
        case 2:
            let journalVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDViewJournalVC") as! TDViewJournalVC
            journalVC.avtarUrl = objProfile.avtarImgUrl
            journalVC.userName = objProfile.userName
            self.present(journalVC, animated: true, completion: nil)

            break
            
        case 3:
            break
            
        case 4:
            let exploreVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDExploreVC") as! TDExploreVC
            self.present(exploreVC, animated: true, completion: nil)

            break
            
        default:
            break
        }
    }
    
    func tapOnTopPortion(){
        
//        rootViewController?.disableInteractivePlayerTransitioning = true
//        self.dismiss(animated: true) { [unowned self] in
//            self.rootViewController?.disableInteractivePlayerTransitioning = false
//        }
        let settingVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDSettingVC") as! TDSettingVC
        self.present(settingVC, animated: true, completion: nil)

    }

    //MARK:- Web Service Method For get Profile Data
    
    func makeWebApiGetProfileWithInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kviewUserProfile) { (result, error) in
            
            self.objProfile = TDUserList.modelFromDict(result as? Dictionary<String, AnyObject>)
            self.currentUserProfile = self.objProfile
            self.homeCollectionView.reloadData()
            self.makeWebApiGetSettingsInfo()
        }
    }
    
    func makeWebApiGetSettingsInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kUserPreference) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if let status = dic["success"] as? Bool {
                    
                    if status {
                        self.settingPreferences =  TDUserPreferences.modelFromDict((dic.validatedValue(KPreference, expected: "" as AnyObject) as! Dictionary<String, AnyObject>))
                    }
                    self.makeWebApiGetCountryList()
                }
            }
        }
    }
    
    func makeWebApiGetCountryList(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kUserCount) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if let status = dic["success"] as? Bool {
                    
                    if status {
                        self.countryList.removeAllObjects()
                        self.countryList =  TDCountryList.modelFromDict(dic)
                    }
                }
            }
        }
    }
    


    //MARK:- Memory Warning Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension TDHomeVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animator = MiniToLargeViewAnimator()
        // animator.initialY = BottomBar.bottomBarHeight
        animator.transitionType = .present
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        let animator = MiniToLargeViewAnimator()
        // animator.initialY = BottomBar.bottomBarHeight
        animator.transitionType = .dismiss
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return presentInteractor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
    {
        guard !disableInteractivePlayerTransitioning else { return nil }
        return dismissInteractor
    }
}

