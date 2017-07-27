//
//  TDSettingVC.swift
//  Qismet
//
//  Created by Lalit on 15/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDSettingVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,TTRangeSliderDelegate {
    
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var doneUpperBtn: UIButton!
    @IBOutlet weak var settingTableView: UITableView!
    
    var objPreferences : TDUserPreferences!
    
//    var disableInteractivePlayerTransitioning = false
//    var isFirstLoad = true
//    var homeVC : TDCameraVC!
//    var presentInteractor: MiniToLargeViewInteractive!
//    var dismissInteractor: MiniToLargeViewInteractive!
    
    var slider: TTRangeSlider?
    var distanceSlider: TTRangeSlider?
    var isEditEmail: Bool = false
//    var bottomBar: BottomBar!
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true
        perform(#selector(toHideStatus), with: nil, afterDelay: 0.7)
    }
    
    func toHideStatus(){
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if isFirstLoad {
//            isFirstLoad = false
//            disableInteractivePlayerTransitioning = true
//            self.present(homeVC, animated: false) { [unowned self] in
//                self.disableInteractivePlayerTransitioning = false
//            }
//        }
//    }

    //MARK:- Helper Methods
    
    func setupDefaults() {
        
        doneBtn.layer.cornerRadius = 10.5
        doneBtn.clipsToBounds = true
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        objPreferences = TDUserPreferences()
        
//        objPreferences.sex = "1"
//        objPreferences.strLowerAge = "18"
//        objPreferences.strUpperAge = "50"
//        objPreferences.strRadius = "90"
//        objPreferences.strRadiusUnit = "Kilometers"
//        objPreferences.isProfileHidden = true
//        objPreferences.isCompliments = true
//        objPreferences.isSavePhoto = true
//        objPreferences.isPrivateJournal = true
//        objPreferences.isSound = true
//        objPreferences.strSearch = "lkjh"
        
        slider = TTRangeSlider(frame: CGRect(x: 70, y: 25, width: kWindowWidth()-100, height: 30))
        distanceSlider = TTRangeSlider(frame: CGRect(x: 70, y: 25, width: kWindowWidth()-100, height: 30))
        
      //  doneBtn.isHidden = true

        self.makeWebApiGetSettingsInfo()
       // prepareView()
    }
    
//    func prepareView() {
//        
////        bottomBar = BottomBar()
////        bottomBar.button.addTarget(self, action: #selector(self.bottomButtonTapped), for: .touchUpInside)
////        bottomBar.translatesAutoresizingMaskIntoConstraints = false
////        self.view.addSubview(bottomBar)
////        
////        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bottomBar]-0-|", options: [], metrics: nil, views: ["bottomBar": bottomBar]))
////        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottomBar(\(BottomBar.bottomBarHeight))]-0-|", options: [], metrics: nil, views: ["bottomBar": bottomBar]))
//        
//
//        homeVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCameraVC") as! TDCameraVC
//        
//        //homeVC.rootViewController = self
//        homeVC.transitioningDelegate = self
//        homeVC.modalPresentationStyle = .fullScreen
//        
//        presentInteractor = MiniToLargeViewInteractive()
//        presentInteractor.attachToViewController(self, withView: UIView(), presentViewController: homeVC)
//        dismissInteractor = MiniToLargeViewInteractive()
//        dismissInteractor.attachToViewController(homeVC, withView: homeVC.view, presentViewController: nil)
//    }
    
    func bottomButtonTapped() {
//        disableInteractivePlayerTransitioning = true
//        self.present(homeVC, animated: true) { [unowned self] in
//            self.disableInteractivePlayerTransitioning = false
//        }
        self.makeWebUpdateSettingsInfo()
    }
    

    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 18
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        switch indexPath.row {
        case 0:
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Show Profiles for"
            cell.dataBtn.isHidden = false
            if objPreferences.sex == "1" {
                cell.dataBtn.setTitle("Men Only", for: .normal)
            }else if objPreferences.sex == "2" {
                cell.dataBtn.setTitle("Women Only", for: .normal)
            }else{
                cell.dataBtn.setTitle("Men & Women", for: .normal)
            }
            cell.dataBtn.addTarget(self, action: #selector(genderAction), for: .touchUpInside)
            cell.sepLbl.isHidden = false
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 1:
            
            let cell:SettingSliderCell = tableView.dequeueReusableCell(withIdentifier: "SettingSliderCell", for: indexPath) as! SettingSliderCell
            cell.headingLbl.text = "Age"
            cell.miBtn.isHidden = true
            cell.kmBtn.isHidden = true
            cell.slashLbl.isHidden = true
            
            slider?.delegate = self
            slider?.minValue = 17
            slider?.maxValue = 60
            slider?.tintColor = RGBA(200, g: 200, b: 200, a: 1.0)
            slider?.tintColorBetweenHandles = UIColor.black
            slider?.lineHeight = 2
            slider?.minLabelColour = UIColor.black
            slider?.maxLabelColour = UIColor.black
            slider?.minDistance = 3
            slider?.handleColor = UIColor.black
            if objPreferences.strUpperAge.length > 0 && objPreferences.strLowerAge.length > 0 {
                
                let min:Float = Float(objPreferences.strLowerAge)!
                let max:Float = Float(objPreferences.strUpperAge)!
                slider?.selectedMinimum = min
                slider?.selectedMaximum = max
            }
            
            cell.contentView.addSubview(slider!)
            
            return cell
            
        case 2:
            
            let cell:SettingSliderCell = tableView.dequeueReusableCell(withIdentifier: "SettingSliderCell", for: indexPath) as! SettingSliderCell
            cell.headingLbl.text = "Dist"
            cell.miBtn.isHidden = false
            cell.kmBtn.isHidden = false
            if objPreferences.strRadiusUnit == "Kilometers" {
                cell.kmBtn.setTitleColor(RGBA(255, g: 0, b: 88, a: 1), for: .normal)
                cell.miBtn.setTitleColor(UIColor.lightGray, for: .normal)
            }else{
                cell.miBtn.setTitleColor(RGBA(255, g: 0, b: 88, a: 1), for: .normal)
                cell.kmBtn.setTitleColor(UIColor.lightGray, for: .normal)
            }
            cell.miBtn.addTarget(self, action: #selector(miBtnAction(_:)), for: .touchUpInside)
            cell.kmBtn.addTarget(self, action: #selector(kmBtnAction(_:)), for: .touchUpInside)
            cell.slashLbl.isHidden = false
            
            distanceSlider?.delegate = self
            distanceSlider?.minValue = 1
            distanceSlider?.maxValue = 100
            distanceSlider?.tintColor = RGBA(200, g: 200, b: 200, a: 1.0)
            distanceSlider?.tintColorBetweenHandles = UIColor.black
            distanceSlider?.lineHeight = 2
            distanceSlider?.minLabelColour = UIColor.black
            distanceSlider?.maxLabelColour = UIColor.black
            distanceSlider?.disableRange = true
            distanceSlider?.handleColor = UIColor.black
            distanceSlider?.selectedMinimum = 1
            distanceSlider?.selectedMaximum = 100
            distanceSlider?.tag = 201
            distanceSlider?.enableStep = true
            distanceSlider?.step = 5.0
            if objPreferences.strRadius.length > 0 {
                distanceSlider?.selectedMaximum = Float(objPreferences.strRadius)!
            }
            cell.contentView.addSubview(distanceSlider!)
            
            return cell
            
        case 3:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Notifications"
            cell.switchBtn.isHidden = false
            cell.switchBtn.isOn = objPreferences.isSound
            cell.switchBtn.tag = 801
            cell.switchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            cell.sepLbl.isHidden = true
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.dataBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 4:
            
            let cell:SettingHeaderCell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell", for: indexPath) as! SettingHeaderCell
            cell.headingLbl.text = "MEMBERSHIP"
            return cell
            
        case 5:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Active"
            cell.switchBtn.isHidden = false
            cell.switchBtn.isOn = !objPreferences.isProfileHidden
            cell.switchBtn.tag = 802
            cell.switchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            cell.sepLbl.isHidden = false
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.dataBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 6:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Save Photos to Camera Roll"
            cell.switchBtn.isHidden = false
            cell.switchBtn.isOn = objPreferences.isSavePhoto
            cell.switchBtn.tag = 803
            cell.switchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            cell.sepLbl.isHidden = false
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.dataBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 7:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.switchBtn.isHidden = false
            cell.switchBtn.isOn = objPreferences.isPrivateJournal
            cell.switchBtn.tag = 804
            cell.switchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            if cell.switchBtn.isOn {
                cell.headingLbl.text = "Story : Private"
                cell.messageLbl.text = "visible only to matches"
            }else{
                cell.headingLbl.text = "Story : Public"
                cell.messageLbl.text = "visible to all members"
            }
            cell.messageLbl.isHidden = false
            cell.sepLbl.isHidden = false
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.dataBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 8:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Receive Compliments"
            cell.switchBtn.isHidden = false
            cell.switchBtn.isOn = objPreferences.isCompliments
            cell.switchBtn.tag = 805
            cell.switchBtn.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
            cell.sepLbl.isHidden = false
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.dataBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 9:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Logout"
            cell.dataBtn.isHidden = true
            cell.sepLbl.isHidden = true
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = true
            cell.cellButton.isHidden = false
            cell.cellButton.addTarget(self, action: #selector(cellButtonAction(_:)), for: .touchUpInside)

            return cell
            
        case 10:
            
            let cell:SettingHeaderCell = tableView.dequeueReusableCell(withIdentifier: "SettingHeaderCell", for: indexPath) as! SettingHeaderCell
            cell.headingLbl.text = "ACCOUNT"
            return cell
            
        case 11:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Email"
            cell.dataBtn.isHidden = true
            cell.sepLbl.isHidden = false
            cell.dataTextField.isHidden = false
            cell.dataTextField.text = userProfile.email
            cell.dataTextField.delegate = self
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 12:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Gender"
            cell.dataBtn.isHidden = true
            cell.sepLbl.isHidden = false
            cell.dataLbl.isHidden = false
            cell.dataLbl.text = "Male"
            cell.dataTextField.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell

        case 13:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Terms & Conditions"
            cell.dataBtn.isHidden = false
            cell.sepLbl.isHidden = false
            cell.dataBtn.setImage(UIImage(named: "arrow2")?.withRenderingMode(.alwaysOriginal), for: .normal)
            cell.cellButton.addTarget(self, action: #selector(cellButtonAction(_:)), for: .touchUpInside)
            cell.dataBtn.setTitle("", for: .normal)
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = false

            return cell
            
        case 14:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Privacy Policy"
            cell.dataBtn.isHidden = false
            cell.sepLbl.isHidden = false
            cell.dataBtn.setImage(UIImage(named: "arrow2")?.withRenderingMode(.alwaysOriginal), for: .normal)
            cell.cellButton.addTarget(self, action: #selector(cellButtonAction(_:)), for: .touchUpInside)
            cell.dataBtn.setTitle("", for: .normal)
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = false

            return cell
            
        case 15:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Security"
            cell.dataBtn.isHidden = false
            cell.sepLbl.isHidden = false
            cell.dataBtn.setImage(UIImage(named: "arrow2")?.withRenderingMode(.alwaysOriginal), for: .normal)
            cell.cellButton.addTarget(self, action: #selector(cellButtonAction(_:)), for: .touchUpInside)

            cell.dataBtn.setTitle("", for: .normal)
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = false

            return cell
            
        case 16:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Contact"
            cell.dataBtn.isHidden = true
            cell.sepLbl.isHidden = false
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell
            
        case 17:
            
            let cell:SettingTableCell = tableView.dequeueReusableCell(withIdentifier: "SettingTableCell", for: indexPath) as! SettingTableCell
            cell.headingLbl.text = "Delete Account"
            cell.dataBtn.isHidden = true
            cell.sepLbl.isHidden = true
            cell.dataTextField.isHidden = true
            cell.dataLbl.isHidden = true
            cell.messageLbl.isHidden = true
            cell.switchBtn.isHidden = true
            cell.cellButton.isHidden = true

            return cell

        default:
            fatalError("Unexpected section \(indexPath.row)")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 4 || indexPath.row == 10{
            return 50
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        switch indexPath.row {
        case 9:
            break
        case 13:
            break
        case 14:
            break
        case 15:
            break
        case 16:
            break
        case 17:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0
    }
    //MARK:- TTRangeSilder Delegate Methods
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        
        if sender.tag == 201 {
            
            let max1 = String(format: "%.0f", selectedMaximum)
            objPreferences.strRadius = max1
        }else{
           
            let min = String(format: "%.0f", selectedMinimum)
            let max = String(format: "%.0f", selectedMaximum)
            
            objPreferences.strLowerAge = min
            objPreferences.strUpperAge = max
        }
        
    }
    
    //MARK:- UITextfield Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        doneBtn.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        doneBtn.isHidden = false
        if textField.text != userProfile.email {
            
            if !(textField.text?.isEmail)! {
                AlertViewController.alert("", message: "Please enter a valid email address", buttons: ["OK"], tapBlock: { (alertAction, index) in
                    if index == 0 {
                        textField.text = userProfile.email
                    }
                })
            }else{
                isEditEmail = true
                userProfile.email = textField.text!
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    //MARK:- UIButton Actions
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        self.makeWebUpdateSettingsInfo()
    }
    
    func miBtnAction(_ sender: UIButton) {
        objPreferences.strRadiusUnit = "Miles"
        self.settingTableView.reloadData()
    }
    
    func kmBtnAction(_ sender: UIButton) {
        objPreferences.strRadiusUnit = "Kilometers"
        self.settingTableView.reloadData()
    }
    
    func switchValueDidChange(_ sender:UISwitch!) {
       
        switch sender.tag {
        case 801:
            objPreferences.isSound = !objPreferences.isSound
        case 802:
            objPreferences.isProfileHidden = !objPreferences.isProfileHidden
        case 803:
            objPreferences.isSavePhoto = !objPreferences.isSavePhoto
        case 804:
            objPreferences.isPrivateJournal = !objPreferences.isPrivateJournal
        case 805:
            objPreferences.isCompliments = !objPreferences.isCompliments
        default:
            break
        }
        self.settingTableView.reloadData()
    }
    
    func cellButtonAction(_ sender:UIButton!) {
        
        let cell = sender.superview?.superview as! SettingTableCell
        let indexPath = self.settingTableView.indexPath(for: cell)! as IndexPath
        
        print("Navigation===-----\(self.navigationController?.viewControllers)")
        switch indexPath.row {
        case 9:
            
           let _ = AlertViewController.actionSheet("Are you sure you want to Logout?", message: "", sourceView: self.view, buttons: ["Sign Out", "Cancel"], tapBlock: { (alertAction, index) in
                if index == 0{
                    self.makeWebApiToLogout()
                }
            })
            break
        case 13:
            let termsVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDTermsAndPrivacyVC") as! TDTermsAndPrivacyVC
            termsVC.navigationBarTitle = "Terms & Conditions"
            self.navigationController?.pushViewController(termsVC, animated: true)

            break
        case 14:
            let termsVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDTermsAndPrivacyVC") as! TDTermsAndPrivacyVC
            termsVC.navigationBarTitle = "Privacy Policy"
            self.navigationController?.pushViewController(termsVC, animated: true)

            break
        case 15:
            let termsVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDTermsAndPrivacyVC") as! TDTermsAndPrivacyVC
            termsVC.navigationBarTitle = "Security"
            self.navigationController?.pushViewController(termsVC, animated: true)
            break
        default:
            break
        }
    }


    
    func genderAction() {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Discover and share other members. Match with the opposite gender.", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let menActionButton: UIAlertAction = UIAlertAction(title: "Men Only", style: .default)
        { action -> Void in
            self.objPreferences.sex = "1"
            self.settingTableView.reloadData()
        }
        actionSheetController.addAction(menActionButton)
        
        let womenActionButton: UIAlertAction = UIAlertAction(title: "Women Only", style: .default)
        { action -> Void in
            self.objPreferences.sex = "2"
            self.settingTableView.reloadData()
        }
        actionSheetController.addAction(womenActionButton)
        
        let bothActionButton: UIAlertAction = UIAlertAction(title: "Men & Women", style: .default)
        { action -> Void in
            self.objPreferences.sex = "3"
            self.settingTableView.reloadData()
        }
        actionSheetController.addAction(bothActionButton)

        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    //MARK:- Web Service Methods
    
    func makeWebApiGetSettingsInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kUserPreference) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if let status = dic["success"] as? Bool {
                    
                    if status {
                       self.objPreferences =  TDUserPreferences.modelFromDict((dic.validatedValue(KPreference, expected: "" as AnyObject) as! Dictionary<String, AnyObject>))
                        self.settingTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func makeWebApiToLogout(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kUserLogout) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if let status = dic["success"] as? Bool {
                    
                    if status {
                        kAppDelegate.logOut()
                    }
                }
            }
        }
    }

    
    func makeWebUpdateSettingsInfo(){
        
        let dictParam = NSMutableDictionary();
        
        dictParam[Klower_age] = NSNumber.init(value: NSInteger.init(objPreferences.strLowerAge)!)
        dictParam[Kupper_age] = NSNumber.init(value: NSInteger.init(objPreferences.strUpperAge)!)
        dictParam[Kgender] = NSNumber.init(value: NSInteger.init(objPreferences.sex)!)
        dictParam[Knotification] = objPreferences.isSound ? 1 : 0
        dictParam[KhideProfile] = objPreferences.isProfileHidden ? 1 : 0
        dictParam[KCompliments] = objPreferences.isCompliments ? 1 : 0
        dictParam[KsavePhoto] = objPreferences.isSavePhoto ? 1 : 0
        dictParam[KprivateJournal] = objPreferences.isPrivateJournal ? 1 : 0
        dictParam[KRadiusUnit] = objPreferences.strRadiusUnit
        dictParam[Kradius] = NSNumber.init(value: NSInteger.init(objPreferences.strRadius)!)
        dictParam[Kcountry] = objPreferences.country
        
        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kUserPreference) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                if let status = dic["success"] as? Bool {
                    
                    if status {
                        
                        if self.isEditEmail {
                            self.isEditEmail = false
                            self.makeWebApiUpdateProfileWithInfo()
                        }else{
//                            self.disableInteractivePlayerTransitioning = true
//                            self.present(self.homeVC, animated: true) { [unowned self] in
//                                self.disableInteractivePlayerTransitioning = false
//                            }
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func makeWebApiUpdateProfileWithInfo(){
        
        let dictParam = NSMutableDictionary();
        
        dictParam[Kusername] = userProfile.userName
        dictParam[Kage] = NSNumber.init(value: NSInteger.init(userProfile.age)!)
        dictParam[Kcountry] = userProfile.country
        if userProfile.sex == "Male" {
            dictParam[Kgender] = NSNumber.init(value: 1)
        }else{
            dictParam[Kgender] = NSNumber.init(value: 2)
        }
        dictParam[Klat] = "77.2090"
        dictParam[Klong] = "26.6139"
        dictParam[Ktagline] = userProfile.interest.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        dictParam[KsnapchatId] = userProfile.snapchatId
        dictParam[Kinstagram] = userProfile.instagramId
        dictParam[ktags] = userProfile.selectedTagArray
        dictParam[Kwork] = userProfile.occupation
        dictParam[Keducation] = userProfile.education
        dictParam[KshowSchool] = userProfile.isShowSchool ? 1 : 0
        dictParam[KshowWork] = userProfile.isShowWork ? 1 : 0
        dictParam[Kcity] = userProfile.cityName
        dictParam[Kstate] = userProfile.stateName
        dictParam[Kemail] = userProfile.email
        
        
        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kviewUserProfile) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                if let status = dic["success"] as? Bool {
                    
                    if status {
//                        self.disableInteractivePlayerTransitioning = true
//                        self.present(self.homeVC, animated: true) { [unowned self] in
//                            self.disableInteractivePlayerTransitioning = false
//                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    
    func makeWebLogoutApp(){
        
        ServiceHelper.callAPIWithParameters([:], method:.post, apiName: kLogout) { (result, error) in
            
        }
    }
    
    func makeWebDeleteAccount(){
        
        ServiceHelper.callAPIWithParameters([:], method:.post, apiName: kDeleteAccount) { (result, error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//extension TDSettingVC: UIViewControllerTransitioningDelegate {
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//        let animator = MiniToLargeViewAnimator()
//       // animator.initialY = BottomBar.bottomBarHeight
//        animator.transitionType = .present
//        return animator
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
//    {
//        let animator = MiniToLargeViewAnimator()
//       // animator.initialY = BottomBar.bottomBarHeight
//        animator.transitionType = .dismiss
//        return animator
//    }
//    
//    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
//    {
//        guard !disableInteractivePlayerTransitioning else { return nil }
//        return presentInteractor
//    }
//    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
//    {
//        guard !disableInteractivePlayerTransitioning else { return nil }
//        return dismissInteractor
//    }
//}

