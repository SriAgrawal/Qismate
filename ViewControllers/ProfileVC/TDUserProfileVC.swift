//
//  TDUserProfileVC.swift
//  Qismet
//
//  Created by Lalit on 10/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit


class TDUserProfileVC: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YSLContainerViewControllerDelegate,UITextViewDelegate,TagsViewSelectDelegate, UIScrollViewDelegate,APParallaxViewDelegate {
    
    @IBOutlet weak var profileTblView: UITableView!
    @IBOutlet weak var topHeaderBackImage: UIImageView!
    @IBOutlet weak var topHeaderTransImage: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var saveUpperBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var topHeaderLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var verifyBtn: UIButton!
    
    var isRefreshFacebookData: Bool = false
    var isScreenEditable: Bool = false
    var isStartEditing: Bool = false
    var isFirstTag: Bool = false
    var isFirstTime: Bool = false
    var objProfile = TDUserList()
    var popUp : STPopupController!
    
    var headerView: HeaderView!
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstTime = true
        self.setUpdefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFirstTime {
            self.profileTblView.addParallax(with: headerView, andHeight: 292)
            self.profileTblView.parallaxView.frame = CGRect(x: 0, y: 0, width: kWindowWidth(), height: 292)
            self.profileTblView.parallaxView.delegate = self
            isFirstTime = false
        }

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- Helper Methods
    
    func setUpdefaults(){
        
        self.makeWebApiGetProfileWithInfo()
        self.profileTblView.delegate = self
        self.profileTblView.dataSource = self
        profileTblView.rowHeight = UITableViewAutomaticDimension
        profileTblView.estimatedRowHeight = 80
        
        saveBtn.layer.cornerRadius = 10.5
        saveBtn.clipsToBounds = true
        
        self.topHeaderBackImage.contentMode = .center
        self.topHeaderBackImage.clipsToBounds = true
        
        headerView = HeaderView.instanceFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapOnProfile))
        headerView.topProfileImageView.addGestureRecognizer(tap)
        
        // screen is initially editable
        
        isScreenEditable = true
//        saveBtn.setTitle("DONE", for: .normal)
//        saveBtn.setImage(UIImage(named : ""), for: .normal)
        saveBtn.setImage(UIImage(named: "whiteCheckIcon"), for: .normal)
        backBtn.isHidden = true
//        saveBtn.backgroundColor = UIColor.white
        saveBtn.contentHorizontalAlignment = .right
        headerView.cameraBtn.isHidden = false
        verifyBtn.isHidden = false
        fbBtn.isHidden = false

    }
    
    func showProfilePopUp() {
        
       let popVC = self.storyboard?.instantiateViewController(withIdentifier: "TDProfilePopUp") as! TDProfilePopUp
        popVC.setContentSize()
        
        popUp = STPopupController(rootViewController: popVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.navigationBarHidden = true
        popUp.containerView.layer.cornerRadius = 5
        popUp.containerView.clipsToBounds = true

        popUp.present(in: self)
    }
    
    
    
    
    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 7;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row {
        case 0:
            let cell:UsernameTableCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTableCell", for: indexPath) as! UsernameTableCell
            cell.usernameLbl.text = "NAME:"
            cell.ageLbl.text = "AGE:"
            cell.ageLbl.isHidden = false
            cell.ageTxtfield.isHidden = false
            cell.ageTxtfield.text = self.objProfile.age
            cell.usernameTxtfield.text = self.objProfile.firstName
            cell.usernameTxtfieldRightConstraint.constant = 112
            cell.usernameTxtfield.isUserInteractionEnabled = false
            cell.ageTxtfield.isUserInteractionEnabled = false
            cell.usernameLbl.textColor = UIColor.black
            cell.countLbl.isHidden = true
            return cell
            
        case 1:
            let cell:UsernameTableCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTableCell", for: indexPath) as! UsernameTableCell
            cell.ageLbl.isHidden = true
            cell.ageTxtfield.isHidden = true
            cell.usernameLbl.text = "USERNAME:"
            cell.usernameTxtfieldRightConstraint.constant = 8
            cell.usernameTxtfield.text = self.objProfile.userName
            cell.usernameTxtfield.isUserInteractionEnabled = true
            cell.usernameTxtfield.delegate = self
            cell.usernameTxtfield.placeholder = "Required"
            cell.usernameTxtfield.tag = 101
            cell.countLbl.isHidden = true
            cell.countLbl.text = "\(self.objProfile.userName.length) / 12"
            if isScreenEditable {
                cell.usernameLbl.textColor = RGBA(51, g: 181, b: 229, a: 1.0)
            }else{
                cell.usernameLbl.textColor = UIColor.black
            }
            return cell
            
        case 2:
            let cell:UsernameTableCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTableCell", for: indexPath) as! UsernameTableCell
            cell.ageLbl.isHidden = true
            cell.ageTxtfield.isHidden = true
            cell.showBtn.isHidden = true
            cell.usernameLbl.text = "LOCATION:"
            cell.usernameTxtfieldRightConstraint.constant = 8
            cell.usernameTxtfield.text = self.objProfile.address
            cell.usernameTxtfield.isUserInteractionEnabled = false
            cell.usernameLbl.textColor = UIColor.black
            cell.countLbl.isHidden = true
            return cell
            
        case 3:
            let cell:UsernameTableCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTableCell", for: indexPath) as! UsernameTableCell
            cell.ageLbl.isHidden = true
            cell.ageTxtfield.isHidden = true
            cell.countLbl.isHidden = true
            cell.usernameLbl.text = "WORK:"
            cell.usernameTxtfieldRightConstraint.constant = 55
            cell.usernameTxtfield.isUserInteractionEnabled = false
            cell.showBtn.isHidden = !isScreenEditable
            cell.showBtn.tag = 511
            cell.showBtn.addTarget(self, action: #selector(showBtnAction(sender:)), for: .touchUpInside)
            if objProfile.isShowWork {
                cell.usernameTxtfield.text = self.objProfile.occupation
                cell.showBtn.setImage(UIImage(named : "turnOn"), for: .normal)
            }else{
                cell.usernameTxtfield.text = "Private"
                cell.showBtn.setImage(UIImage(named : "turnOff"), for: .normal)
            }
            return cell
            
        case 4:
            let cell:UsernameTableCell = tableView.dequeueReusableCell(withIdentifier: "UsernameTableCell", for: indexPath) as! UsernameTableCell
            cell.ageLbl.isHidden = true
            cell.ageTxtfield.isHidden = true
            cell.countLbl.isHidden = true
            cell.usernameLbl.text = "SCHOOL:"
            cell.usernameTxtfieldRightConstraint.constant = 55
            cell.usernameTxtfield.isUserInteractionEnabled = false
            cell.showBtn.isHidden = !isScreenEditable
            cell.showBtn.tag = 512
            if objProfile.education.range(of:",") != nil {
                objProfile.education = objProfile.education.components(separatedBy: ",")[0]
            }
            cell.showBtn.addTarget(self, action: #selector(showBtnAction(sender:)), for: .touchUpInside)
            if objProfile.isShowSchool {
                cell.usernameTxtfield.text = self.objProfile.education
                cell.showBtn.setImage(UIImage(named : "turnOn"), for: .normal)
            }else{
                cell.usernameTxtfield.text = "Private"
                cell.showBtn.setImage(UIImage(named : "turnOff"), for: .normal)
            }
            return cell
            
        case 5:
            let cell:SnapChatTableCell = tableView.dequeueReusableCell(withIdentifier: "SnapChatTableCell", for: indexPath) as! SnapChatTableCell
            
            cell.snapchatTxtField.text = self.objProfile.snapchatId
            cell.instagramTxtfield.text = self.objProfile.instagramId
            cell.snapchatTxtField.delegate = self
            cell.instagramTxtfield.delegate = self
            cell.snapchatTxtField.tag = 103
            cell.instagramTxtfield.tag = 102
            if isScreenEditable {
                cell.snapchatLbl.textColor = RGBA(51, g: 181, b: 229, a: 1.0)
                cell.instagramLbl.textColor = RGBA(51, g: 181, b: 229, a: 1.0)
            }else{
                cell.snapchatLbl.textColor = UIColor.black
                cell.instagramLbl.textColor = UIColor.black
            }

            return cell
            
        case 6:
            let cell:TagsTableCell = tableView.dequeueReusableCell(withIdentifier: "TagsTableCell", for: indexPath) as! TagsTableCell
            cell.selectBtn.addTarget(self, action: #selector(tagAction), for: .touchUpInside)
            if isScreenEditable {
                cell.tagLbl.textColor = RGBA(51, g: 181, b: 229, a: 1.0)
            }else{
                cell.tagLbl.textColor = UIColor.black
            }
            if objProfile.tags.length > 0 {
                cell.dataLbl.text = objProfile.tags
                cell.selectBtn.isHidden = true
                let tap = UITapGestureRecognizer(target: self, action:#selector(tagAction))
                cell.dataLbl.addGestureRecognizer(tap)
                
            }else{
                cell.dataLbl.text = ""
                cell.selectBtn.isHidden = false
            }
            return cell
            
        case 7:
            let cell:AboutTextTableCell = tableView.dequeueReusableCell(withIdentifier: "AboutTextTableCell", for: indexPath) as! AboutTextTableCell
            cell.aboutTextView.text = self.objProfile.interest
            cell.aboutTextView.placeholderText = "Tell us about yourself or get creative with emoji."
            cell.aboutTextView.placeholderColor = UIColor.lightGray
            cell.aboutTextView.isScrollEnabled = false
            cell.aboutTextView.delegate = self
            if isScreenEditable {
                cell.aboutLbl.textColor = RGBA(51, g: 181, b: 229, a: 1.0)
                 cell.countLbl.isHidden = false
            }else{
                cell.aboutLbl.textColor = UIColor.black
                cell.countLbl.isHidden = true
            }
            cell.countLbl.text = "\(Int(200) - objProfile.interest.length)"
            return cell
            
        default:
            fatalError("Unexpected section \(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 6:
            
            return  CGFloat(objProfile.tags.setHeightWithText(strText: objProfile.tags, width: 18.0, fontName: kAppFontMediumWithSize(17))) + 55
            
        case 7:
            return 190
            
        default:
            break
        }
        return 80;
    }
    //MARK:- UIButton Actions
    
    func showBtnAction(sender: UIButton){
        isStartEditing = true
        if sender.tag == 511 {
            objProfile.isShowWork = !objProfile.isShowWork
        }else if sender.tag == 512{
            objProfile.isShowSchool = !objProfile.isShowSchool
        }
        self.profileTblView.reloadData()
        fbBtn.isHidden = true
        verifyBtn.isHidden = true
        headerView.cameraBtn.isHidden = true
        cancelBtn.isHidden = false
    }
    
    @IBAction func cameraBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func fbBtnAction(_ sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let menActionButton: UIAlertAction = UIAlertAction(title: "Refresh Facebook", style: .default)
        { action -> Void in
            
            let _ = AlertViewController.alert("Update Info", message: "All data and photos will be refreshed from Facebook", buttons: ["Cancel","Refresh"], tapBlock: { (alertAction, index) in
                if index == 1 {
                    self.makeWebApiCallToRefreshFacebookData()
                }
            })
        }
        actionSheetController.addAction(menActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let menActionButton: UIAlertAction = UIAlertAction(title: "Discard Changes", style: .default)
        { action -> Void in
            
            self.isStartEditing = false
//            self.isScreenEditable  = false
//            self.cancelBtn.isHidden = true
//            self.backBtn.isHidden = false
//            self.saveBtn.setTitle("", for: .normal)
//            self.saveBtn.setImage(UIImage(named: "profileEditIcon"), for: .normal)
//            self.saveBtn.backgroundColor = UIColor.clear
//            self.saveBtn.contentHorizontalAlignment = .right
            self.saveBtn.setImage(UIImage(named: "whiteCheckIcon"), for: .normal)
            self.cancelBtn.isHidden = true
            self.saveBtn.contentHorizontalAlignment = .right
            self.headerView.cameraBtn.isHidden = false
            self.verifyBtn.isHidden = false
            self.fbBtn.isHidden = false
            
            self.makeWebApiGetProfileWithInfo()
        }
        actionSheetController.addAction(menActionButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func dismissBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if saveBtn.image(for: .normal) == UIImage(named: "profileEditIcon"){
            isScreenEditable = true
//            saveBtn.setTitle("DONE", for: .normal)
//            saveBtn.setImage(UIImage(named : ""), for: .normal)
//            saveBtn.backgroundColor = UIColor.white
            saveBtn.setImage(UIImage(named : "whiteCheckIcon"), for: .normal)
            backBtn.isHidden = true
            saveBtn.contentHorizontalAlignment = .right
            headerView.cameraBtn.isHidden = false
            verifyBtn.isHidden = false
            fbBtn.isHidden = false
        }else{
            if isStartEditing {
                if objProfile.isUsernameAvailable != 2 && objProfile.isUsernameAvailable != 3 {
                    self.makeWebApiUpdateProfileWithInfo()
                }
            }else{
//                isScreenEditable = false
//                saveBtn.setTitle("", for: .normal)
//                saveBtn.setImage(UIImage(named: "profileEditIcon"), for: .normal)
//                backBtn.isHidden = false
//                saveBtn.backgroundColor = UIColor.clear
//                saveBtn.contentHorizontalAlignment = .right
//                headerView.cameraBtn.isHidden = true
//                verifyBtn.isHidden = true
//                fbBtn.isHidden = true
//                self.profileTblView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.profileTblView.reloadData()
    }
    func backBtnAction() {
        popUp.dismiss()
    }
    func tapOnProfile(){
        if !isScreenEditable {
            showProfilePopUp()
        }
    }
    
    func tagAction() {
        
        if isScreenEditable {
            
            let tagVC = self.storyboard?.instantiateViewController(withIdentifier: "TDTagsVC") as! TDTagsVC
            tagVC.title = "INTERESTS"
            tagVC.screenType = "hobbies"
            tagVC.delegate = self
            tagVC.pastSelectedTags = objProfile.hobbieTagArray
            
            let tagVC1 = self.storyboard?.instantiateViewController(withIdentifier: "TDTagsVC") as! TDTagsVC
            tagVC1.title = "DETAILS"
            tagVC1.screenType = "personalities"
            tagVC1.delegate = self
            tagVC1.pastSelectedTags = objProfile.personalityTagArray
            
            let containerVC = YSLContainerViewController(controllers:[tagVC,tagVC1], topBarHeight: 40, parentViewController: self) as YSLContainerViewController
            containerVC.setContentSize()
            containerVC.menuItemTitleColor = UIColor.init(white: 1.0, alpha: 0.3)
            containerVC.menuItemSelectedTitleColor = UIColor.white
            containerVC.menuIndicatorColor = UIColor.white
            containerVC.view.backgroundColor = UIColor.clear
            containerVC.menuItemFont = kAppFontBoldWithSize(13)
            containerVC.delegate = self
            
            popUp = STPopupController(rootViewController: containerVC)
            popUp.containerView.backgroundColor = UIColor.clear
            popUp.navigationBarHidden = true
            popUp.style = STPopupStyle.bottomSheet
            popUp.transitionStyle = STPopupTransitionStyle.fade
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = popUp.containerView.bounds
            blurView.autoresizingMask = .flexibleWidth
            popUp.containerView.addSubview(blurView)
            popUp.containerView.sendSubview(toBack: blurView)
            
            let image = UIImage(named: "arrowWhite")
            let backBtn : UIButton!
            backBtn = UIButton()
            backBtn.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
            backBtn.setImage(image, for: .normal)
            backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
            popUp.containerView.addSubview(backBtn)
            
            let image1 = UIImage(named: "tagIcon")
            let tagBtn : UIButton!
            tagBtn = UIButton()
            tagBtn.frame = CGRect(x: (kWindowWidth()-40)/2, y: 5, width: 40, height: 40)
            tagBtn.setImage(image1, for: .normal)
            tagBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
            popUp.containerView.addSubview(tagBtn)
            
            popUp.present(in: self)
        }
    }
    
    //MARK:- TDTagsVC Delegate Methods
    
    func selectedTagsData(selectedArray: Array<Any>, screenType: String) {
        
        if !isFirstTag {
            isFirstTag = true
        }else{
            isFirstTag = false
        }
        
        if screenType ==  "hobbies"{
            objProfile.hobbieTagArray = selectedArray
        }else{
            objProfile.personalityTagArray = selectedArray
        }
        
        if !isFirstTag {
            
            isStartEditing = true
            let finalArray: [Any] = objProfile.hobbieTagArray + objProfile.personalityTagArray
            var isSame = true
            for i in 0...finalArray.count - 1 {
                if (finalArray[i] as! String) != (objProfile.selectedTagArray[i] as! String) {
                    isSame = false
                    break
                }
            }
            if !isSame {
                fbBtn.isHidden = true
                verifyBtn.isHidden = true
                headerView.cameraBtn.isHidden = true
                cancelBtn.isHidden = false
                
                objProfile.selectedTagArray = finalArray
                var tag = ""
                for item in objProfile.selectedTagArray {
                    if tag == "" {
                        tag = item as! String
                    }else{
                        let str = item as! String
                        tag = tag + ", "+str
                    }
                }
                objProfile.tags = tag
                self.profileTblView.reloadData()
                
            }
            
        }
    }
    
    //MARK:- APParallex Delegate Methods
    
    func parallaxView(_ view: APParallaxView!, didChangeFrame frame: CGRect) {
        
        print(frame.size.height)
        
        if frame.size.height < 56.0 {
            
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.topHeaderLbl.alpha = 1.0
                self.topHeaderBackImage.alpha = 1.0
                self.topHeaderTransImage.alpha = 1.0
                self.backBtn.alpha = 0.0
            }, completion: { _ in })
            
        }else{
            
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.topHeaderLbl.alpha = 0.0
                self.topHeaderBackImage.alpha = 0.0
                self.topHeaderTransImage.alpha = 0.0
                self.backBtn.alpha = 1.0
            }, completion: { _ in })
        }
        
        if frame.size.height < 270 && frame.size.height > 135 && headerView.profileImageView.alpha >= 0.3{
            let alpha:CGFloat = self.headerView.profileImageView.alpha - 0.008
            self.headerView.profileImageView.alpha = alpha
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.headerView.avtarImageView.alpha = 1.0
                self.headerView.cameraBtn.alpha = 1.0
            }, completion: { _ in })
        }else if frame.size.height < 135 && headerView.profileImageView.alpha <= 1.0 {
            let alpha:CGFloat = headerView.profileImageView.alpha+0.005;
            self.headerView.profileImageView.alpha=alpha;
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.headerView.avtarImageView.alpha = 0.0
                self.headerView.cameraBtn.alpha = 0.0
            }, completion: { _ in })
        }
        
        if frame.size.height == 292 {
            
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.headerView.profileImageView.alpha = 1.0
                self.headerView.avtarImageView.alpha = 1.0
                self.headerView.cameraBtn.alpha = 1.0
                self.fbBtn.alpha = 1.0
                self.verifyBtn.alpha = 1.0
            }, completion: { _ in })
            
        }else{
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
//                self.fbBtn.alpha = 0.0
//                self.verifyBtn.alpha = 0.0
            }, completion: { _ in })
        }

        
        if frame.size.height > 400 {
            if !isScreenEditable {
                
                UIView.animate(withDuration: 0.3, animations: {() -> Void in
                }, completion: { _ in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    //MARK:- UIScrollView Delegate Methods
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView){
//        
//        let offset : CGFloat = scrollView.contentOffset.y
//        if offset > 230 {
//            
//            UIView.animate(withDuration: 0.3, animations: {() -> Void in
//                self.topHeaderLbl.alpha = 1.0
//                self.topHeaderBackImage.alpha = 1.0
//                self.topHeaderTransImage.alpha = 1.0
//                self.backBtn.alpha = 0.0
//            }, completion: { _ in })
//            
//        }else{
//            
//            UIView.animate(withDuration: 0.3, animations: {() -> Void in
//                self.topHeaderLbl.alpha = 0.0
//                self.topHeaderBackImage.alpha = 0.0
//                self.topHeaderTransImage.alpha = 0.0
//                self.backBtn.alpha = 1.0
//            }, completion: { _ in })
//        }
//    }
    

    
    //MARK:- UITextfield Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if !isScreenEditable {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        saveBtn.isHidden = true
        saveUpperBtn.isHidden = true
        fbBtn.isHidden = true
        verifyBtn.isHidden = true
        cancelBtn.isHidden = true
        headerView.cameraBtn.isHidden = true
        
        if textField.tag == 101 {
            
            let indexPath = IndexPath.init(row: 1, section: 0)
            let editCell = self.profileTblView.cellForRow(at: indexPath) as! UsernameTableCell
            editCell.countLbl.isHidden = false

            objProfile.isUsernameAvailable = 0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
        if textField.tag == 101 {
//            if objProfile.isUsernameAvailable == 1 {
//                objProfile.userName = textField.text!
//            }
            if textField.text != self.objProfile.userName {
                self.makeWebApiCallToCheckUsername(text: trimWhiteSpace(textField.text!));
            }
            let indexPath = IndexPath.init(row: 1, section: 0)
            let editCell = self.profileTblView.cellForRow(at: indexPath) as! UsernameTableCell
            editCell.countLbl.isHidden = true


        }else if textField.tag == 102{
            objProfile.instagramId = textField.text!
        }else if textField.tag == 103{
            objProfile.snapchatId = textField.text!
        }
        saveBtn.isHidden = false
        saveUpperBtn.isHidden = false
        if isStartEditing {
            cancelBtn.isHidden = false
        }else{
            fbBtn.isHidden = false
            verifyBtn.isHidden = false
            headerView.cameraBtn.isHidden = false
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        isStartEditing = true
        let newText: NSString = (textField.text ?? "") as NSString
        let strText = newText.replacingCharacters(in: range, with: string)
        if textField.tag == 100 {
            
        }
        else if(textField.tag == 101){
            
            let indexPath = IndexPath.init(row: 1, section: 0)
            let editCell = self.profileTblView.cellForRow(at: indexPath) as! UsernameTableCell

            let nameRegex: String = "[A-Za-z0-9]+"  //Username contains alphabets and numeric
            let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
            
            if strText.length > 0 && range.length == 0 {
                if !(nameTest.evaluate(with: strText)) {
                    return false
                }
            }
            if strText.length>12 {
                return false
            }
            else if strText.length>4 {
//                if strText != self.objProfile.userName {
//                    self.makeWebApiCallToCheckUsername(text: strText);
//                }
//                else{
                
                    self.objProfile.isUsernameAvailable = 1;
                    editCell.usernameLbl.text = "Select 5-12 char (A-Z, 0-9)";
                    editCell.usernameLbl.textColor = RGBA(51, g: 181, b: 229, a: 1.0)
                    editCell.countLbl.text = "\(strText.length) / 12"
              //  }
            }
            else{
                
                self.objProfile.isUsernameAvailable = 3;
                editCell.usernameLbl.text = "Select 5-12 char (A-Z, 0-9)";
                editCell.usernameLbl.textColor = UIColor.red
                editCell.countLbl.text = "\(strText.length) / 12"
            }
        }

        return true
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.profileTblView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        return true
    }
    
    //MARK:- UITextView Delegate Methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        if !isScreenEditable {
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        saveBtn.isHidden = true
        saveUpperBtn.isHidden = true
        fbBtn.isHidden = true
        verifyBtn.isHidden = true
        cancelBtn.isHidden = true
        headerView.cameraBtn.isHidden = true

    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        
        objProfile.interest = textView.text!
        print(objProfile.interest)
        saveBtn.isHidden = false
        saveUpperBtn.isHidden = false
        if isStartEditing {
            cancelBtn.isHidden = false
        }else{
            fbBtn.isHidden = false
            verifyBtn.isHidden = false
            headerView.cameraBtn.isHidden = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        if text == "\n" {
            textView.resignFirstResponder()
            self.profileTblView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            return false
        }
        isStartEditing = true
        let newString: String = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if newString.length < 201 {
            return true
        }else{
            return false
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        
        let indexPath = IndexPath(row: 7, section: 0)
        let editCell: AboutTextTableCell? = (self.profileTblView.cellForRow(at: indexPath) as? AboutTextTableCell)
        
        editCell?.countLbl?.text = "\(Int(200) - textView.text.length)"
        
    }
    
    //MARK:- Web Service Method For get Profile Data
    
    func makeWebApiGetProfileWithInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kviewUserProfile) { (result, error) in
            
            self.objProfile = TDUserList.modelFromDict(result as? Dictionary<String, AnyObject>)
            self.objProfile.isUsernameAvailable = 0;
            self.headerView.profileImageView.sd_setImage(with: self.objProfile.profilePicUrl, completed: { (image, error, type, url) in
                self.topHeaderBackImage.image = image
            })
            self.headerView.avtarImageView.sd_setImage(with: self.objProfile.avtarImgUrl, placeholderImage: nil, options: .refreshCached)
            self.topHeaderLbl.text = self.objProfile.firstName
            
            if self.isRefreshFacebookData {
                self.isRefreshFacebookData = false
                self.isStartEditing = false
                self.isScreenEditable  = false
                self.cancelBtn.isHidden = true
                self.backBtn.isHidden = false
                self.saveBtn.setTitle("", for: .normal)
                self.saveBtn.setImage(UIImage(named: "profileEditIcon"), for: .normal)
                self.saveBtn.backgroundColor = UIColor.clear
                self.saveBtn.contentHorizontalAlignment = .right
                self.fbBtn.isHidden = true
                self.verifyBtn.isHidden = true
                self.headerView.cameraBtn.isHidden = true
            }

            self.profileTblView.reloadData()
        }
    }
    
    func makeWebApiUpdateProfileWithInfo(){
        
        let dictParam = NSMutableDictionary();
        
        dictParam[Kusername] = objProfile.userName
        dictParam[Kage] = NSNumber.init(value: NSInteger.init(objProfile.age)!)
        dictParam[Kcountry] = objProfile.country
        if objProfile.sex == "Male" {
            dictParam[Kgender] = NSNumber.init(value: 1)
        }else{
            dictParam[Kgender] = NSNumber.init(value: 2)
        }
        dictParam[Klat] = "77.2090"
        dictParam[Klong] = "26.6139"
        dictParam[Ktagline] = objProfile.interest.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        dictParam[KsnapchatId] = objProfile.snapchatId
        dictParam[Kinstagram] = objProfile.instagramId
        dictParam[ktags] = objProfile.selectedTagArray
        dictParam[Kwork] = objProfile.occupation
        dictParam[Keducation] = objProfile.education
        dictParam[KshowSchool] = objProfile.isShowSchool ? 1 : 0
        dictParam[KshowWork] = objProfile.isShowWork ? 1 : 0
        dictParam[Kcity] = objProfile.cityName
        dictParam[Kstate] = objProfile.stateName

        
        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kviewUserProfile) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                if let status = dic["success"] as? Bool {
                    
                    if status {
//                        self.isScreenEditable = false
//                        self.saveBtn.setTitle("", for: .normal)
//                        self.saveBtn.setImage(UIImage(named: "profileEditIcon"), for: .normal)
//                        self.backBtn.isHidden = false
//                        self.cancelBtn.isHidden = true
//                        self.saveBtn.backgroundColor = UIColor.clear
//                        self.saveBtn.contentHorizontalAlignment = .right
//                        self.headerView.cameraBtn.isHidden = true
//                        self.verifyBtn.isHidden = true
//                        self.fbBtn.isHidden = true
//                        self.profileTblView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.profileTblView.reloadData()
                }
            }
        }
    }
    
    func makeWebApiCallToCheckUsername(text:String){
        
        let dictParam = NSMutableDictionary();
        dictParam[Kusername] = text

        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kCheckUsername) { (result, error) in
            
            let indexPath = IndexPath.init(row: 1, section: 0)
            let editCell = self.profileTblView.cellForRow(at: indexPath) as! UsernameTableCell
            if let dic = result as? Dictionary<String, AnyObject> {
                if let status = dic["success"] as? Bool {
                    
                    if status {
                        if ((editCell.usernameTxtfield.text?.length)!>4) {
                            editCell.usernameLbl.text = "AVAILABLE";
                            editCell.usernameLbl.textColor = RGBA(51, g: 181, b: 229, a: 1.0)
                            self.objProfile.isUsernameAvailable = 1;
                            self.objProfile.userName = text
                        }
                        logInfo("Status is true")
                    } else {
                        
                        if ((editCell.usernameTxtfield.text?.length)!>4) {
                            editCell.usernameLbl.text = "TAKEN";
                            editCell.usernameLbl.textColor = UIColor.red
                            self.objProfile.isUsernameAvailable = 2;
                        }
                        logInfo("Status is false")
                    }
                }
                
            }
        }
    }
    
    func makeWebApiCallToRefreshFacebookData(){
        
        let dictParam = NSMutableDictionary();
        dictParam[Kfb_token] = UserDefaults.standard.object(forKey: Kfb_token)
        isRefreshFacebookData = true
        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kRefreshFacebook) { (result, error) in
                
            self.makeWebApiGetProfileWithInfo()
        }
    }

    
    //MARK:- Memory Warning Methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
