//
//  TDViewJournalVC.swift
//  Qismet
//
//  Created by Lalit on 20/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDViewJournalVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, EditJournalDelegate {
    
    @IBOutlet weak var journalCollectionView: UICollectionView!
    
    @IBOutlet weak var progressView: MRCircularProgressView!
    @IBOutlet weak var avtarImgView: UIImageView!
    @IBOutlet weak var dotBtn: UIButton!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var usernameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotBtnTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnTopConstraint: NSLayoutConstraint!
    
    var journalArray = NSMutableArray()
    var avtarUrl : URL!
    var userName : String!
    var popUp : STPopupController!
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDefaults()
        self.makeWebApiGetProfileWithInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- Helper Methods
    
    
    func setUpDefaults() {
        

        journalCollectionView.delegate = self
        journalCollectionView.dataSource = self
        
        avtarImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnAvtar)))
        
        countLbl.layer.cornerRadius = countLbl.frame.size.height/2
        countLbl.clipsToBounds = true
        
        self.progressView.progressColor = UIColor.white
        self.progressView.wrapperColor = UIColor.darkGray
        self.progressView.wrapperArcWidth = 1.5
        self.progressView.progressArcWidth = 1.5
        self.progressView.backgroundColor = UIColor.clear
        
        let notificationName = Notification.Name("RefreshViewJournal")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: notificationName, object: nil)
        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
//        self.journalCollectionView.addGestureRecognizer(panGestureRecognizer)

    }
    
    func setProgressBar(_ index: Int) {
        let a: Int = journalArray.count
        let max: CGFloat = CGFloat(a)
        self.progressView.setProgress(CGFloat(index) / max, animated: true)
    }
    
    func refreshScreen(){
        
        usernameTopConstraint.constant = 11
        dotBtnTopConstraint.constant = 0
        backBtnTopConstraint.constant = 0
        self.makeWebApiGetProfileWithInfo()
    }
    
    func tapOnAvtar() {
        
        let popVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDProfilePopUp") as! TDProfilePopUp
        popVC.setContentSize()
        
        popUp = STPopupController(rootViewController: popVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.navigationBarHidden = true
        popUp.containerView.layer.cornerRadius = 5
        popUp.containerView.clipsToBounds = true
       // popUp.delegate = self
        popUp.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        
        let editButton = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        editButton.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        editButton.setImage(UIImage(named: "profileEditIcon"), for: .normal)
        popUp.backgroundView.addSubview(editButton)
        
        let settingButton = UIButton(frame: CGRect(x: (kWindowWidth()-50), y: 10, width: 40, height: 40))
        settingButton.setImage(UIImage(named: "settingIcon"), for: .normal)
        settingButton.addTarget(self, action: #selector(settingBtnAction), for: .touchUpInside)
        popUp.backgroundView.addSubview(settingButton)
        
        self.isHiddenIcons(true)
        
        popUp.present(in: kAppDelegate.navController)
    }
    
    func editBtnAction(){
        self.isHiddenIcons(false)
        popUp.dismiss()
        let profileVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDUserProfileVC") as! TDUserProfileVC
        self.present(profileVC, animated: true, completion: nil)
    }
    
    func settingBtnAction(){
        popUp.dismiss()
        self.isHiddenIcons(false)
        let settingVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDSettingVC") as! TDSettingVC
        self.present(settingVC, animated: true, completion: nil)
        
    }
    
    func dismissPopup() {
        self.isHiddenIcons(false)
        popUp.dismiss()
    }
    
    func isHiddenIcons(_ status:Bool) {
        
        dotBtn.isHidden = status
        avtarImgView.isHidden = status
        countLbl.isHidden = status
        progressView.isHidden = status
        backBtn.isHidden = status
        
    }


    
    //MARK:- UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return journalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewJournalCell", for: indexPath) as! ViewJournalCell
        let objJournal = self.journalArray.object(at: indexPath.row) as! TDJournalList
        cell.tempImageView.sd_setImage(with: objJournal.journalImageUrl, completed: { (image, error, type, url) in
            cell.motionView.image = image
        })
        
        if objJournal.journalText.length > 0 {
            cell.journalTextLbl.text = objJournal.journalText
            cell.journalLblHeightConstraint.constant = CGFloat(objJournal.journalText.setHeightWithText(strText: objJournal.journalText, width: 20, fontName: kAppFontItalicWithSize(22))+5)
        }else{
            cell.journalTextLbl.text = ""
            cell.journalLblHeightConstraint.constant = 5
        }
        
        if objJournal.suggestionStr.length > 0 {
            cell.suggestionLbl.text = objJournal.suggestionStr.uppercased()
            cell.suggestionLblHeightConstraint.constant = CGFloat(objJournal.suggestionStr.setHeightWithText(strText: objJournal.suggestionStr, width: 20, fontName: kAppFontBoldWithSize(14)))
        }else{
             cell.suggestionLbl.text = ""
            cell.suggestionLblHeightConstraint.constant = 5
        }
        
        cell.locationLbl.tag = indexPath.row + 1000

        
        if objJournal.timestamp.length > 0 && objJournal.location.length > 0 {
            cell.locationLbl.text = "\(objJournal.timestamp) • \(objJournal.location)"
        }else if objJournal.timestamp.length < 1  && objJournal.location.length > 0{
            cell.locationLbl.text = "\(objJournal.location)"
        }else if objJournal.timestamp.length > 0  && objJournal.location.length < 1{
            cell.locationLbl.text = "\(objJournal.timestamp)"
        }else{
            cell.locationLbl.text = ""
        }
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapOnCell(_:)))
        cell.addGestureRecognizer(tap)
        
        let locationTap = UITapGestureRecognizer(target: self, action:#selector(tapOnLocation(_:)))
        cell.locationLbl.addGestureRecognizer(locationTap)

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: kWindowWidth(), height: kWindowHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    func tapOnLocation(_ sender: UITapGestureRecognizer) {
        
        let locLbl: UILabel? = (sender.view as? UILabel)
        let objJournal = self.journalArray.object(at: (locLbl?.tag)!-1000) as! TDJournalList
        
        if objJournal.location.length > 0 {
            
            let popVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDJournalPopUpVC") as! TDJournalPopUpVC
            popVC.setContentSize()
            popVC.objSelectedJournal = objJournal
            
            popUp = STPopupController(rootViewController: popVC)
            popUp.containerView.backgroundColor = UIColor.clear
            popUp.navigationBarHidden = true
            popUp.containerView.layer.cornerRadius = 5
            popUp.containerView.clipsToBounds = true
            
            popUp.present(in: self)

        }
        
    }
    
    func tapOnCell(_ sender: UITapGestureRecognizer) {
        
        let cell: ViewJournalCell? = (sender.view as? ViewJournalCell)
        let touchPoint: CGPoint = sender.location(in: cell)
        let index1: CGFloat = journalCollectionView.contentOffset.x / journalCollectionView.bounds.size.width
        var index: Int = Int(index1)
        if touchPoint.x <= kWindowWidth() / 2 && touchPoint.y <= kWindowHeight() - 50 {
            // NSLog(@"left");
            if index > 0 {
                index = index - 1
            }
            else {
                index = journalArray.count - 1
            }
        }else if touchPoint.x >= kWindowWidth() / 2 && touchPoint.y <= kWindowHeight() - 50 {
            // NSLog(@"right");
            if index < journalArray.count - 1 {
                index = index + 1
            }
            else {
                index = 0
            }
        }
        journalCollectionView.setContentOffset(CGPoint(x: CGFloat(index) * kWindowWidth(), y: CGFloat(0)), animated: false)
        self.countLbl.text = String(journalArray.count - index)
        self.setProgressBar(index+1)
    }
    
    
    @IBAction func dotBtnAction(_ sender: UIButton) {
        
        let index: Int = Int(journalCollectionView.contentOffset.x / journalCollectionView.bounds.size.width)
        let obj = self.journalArray.object(at: index) as! TDJournalList
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        if obj.journalText.length > 0 {
            let editTextButton: UIAlertAction = UIAlertAction(title: "Edit Text", style: .default)
            { action -> Void in
                let editVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDEditJournalVC") as! TDEditJournalVC
                editVC.objJournal = obj
                editVC.delegate = self
                self.present(editVC, animated: true, completion: nil)
            }
            actionSheetController.addAction(editTextButton)
        }
        if obj.suggestionStr.length > 0 {
            let editTitleButton: UIAlertAction = UIAlertAction(title: "Edit Title", style: .default)
            { action -> Void in
                let editVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDEditJournalVC") as! TDEditJournalVC
                editVC.isEditTitle = true
                editVC.objJournal = obj
                editVC.delegate = self
                self.present(editVC, animated: true, completion: nil)
            }
            actionSheetController.addAction(editTitleButton)
        }
        
        let deleteButton: UIAlertAction = UIAlertAction(title: "Delete", style: .default)
        { action -> Void in
            
            let _ = AlertViewController.alert("Delete", message: "Delete this moment from your story ?", buttons: ["Cancel","Delete"], tapBlock: { (alertAction, index) in
                if index == 0 {
                   
                }else{
                    self.makeWebApiDeleteJournal(obj)
                }
            })
        }
        actionSheetController.addAction(deleteButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
      
        
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
            
            if velocity.y >= 200 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }else if velocity.y <= -5{
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                    self.showProfilePopUp()
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
    
    func showProfilePopUp() {
        
        let popVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDProfilePopUp") as! TDProfilePopUp
        popVC.setContentSize()
        
        popUp = STPopupController(rootViewController: popVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.navigationBarHidden = true
        popUp.containerView.layer.cornerRadius = 5
        popUp.containerView.clipsToBounds = true
        
        popUp.present(in: self)

    }
    
    //MARK:- EditJournalDelegate Methods
    
    func setViewConstraintOnDisappear(){
        
        usernameTopConstraint.constant = 11
        dotBtnTopConstraint.constant = 0
        backBtnTopConstraint.constant = 0
    }

    
    
    //MARK:- Web Service Method For get Profile Data
    
    func makeWebApiGetProfileWithInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kJournalService) { (result, error) in
            self.journalArray.removeAllObjects()
            if let response = result as? Dictionary<String, AnyObject> {
                let journalsData = response.validatedValue(Kjournals, expected: NSArray() as AnyObject) as! NSArray
                for item in journalsData
                {
                    let dict = item as! Dictionary<String, AnyObject>
                    self.journalArray.add(TDJournalList .modelFromDict(dict))
                }
                self.countLbl.text = "\(self.journalArray.count)"
                 let objJournal = self.journalArray.object(at: 0) as! TDJournalList
                self.usernameLbl.text = objJournal.userName
                self.avtarImgView.sd_setImage(with: objJournal.avtarImgUrl)

                self.journalCollectionView.reloadData()
                self.setProgressBar(1)
            }
        }
    }
    
    func makeWebApiDeleteJournal(_ selectedJournal:TDJournalList){
        
        let dictParam = NSMutableDictionary();
        dictParam[Kid] = Int(selectedJournal.journalId)
        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kDeleteJournal) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                if let status = dic["success"] as? Bool {
                    if status {
                        self.makeWebApiGetProfileWithInfo()
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
