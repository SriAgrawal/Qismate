//
//  TDExploreVC.swift
//  Qismet
//
//  Created by Suresh patel on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import RAMReel

class TDExploreVC: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,CountrySelectDelegate {
    
    @IBOutlet weak var exploreTableView: UITableView!
    @IBOutlet weak var headerCountryLbl: UILabel!
    @IBOutlet weak var countryTableView: UITableView!
    
    
    var objPreferences : TDUserPreferences!
    var discoverDataList = NSMutableArray()
    var dataSource: SimplePrefixQueryDataSource!
    var ramReel: RAMReel<RAMCell, RAMTextField, SimplePrefixQueryDataSource>!
    var countryArray:[String] = []
    var selectedCountry : String = ""
    
    var popUp : STPopupController!
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    
    //MARK:- Class Helper Methods
    
    func setupDefaults(){
        
        settingPreferences.strSearch = "country"
        settingPreferences.country = userProfile.country
        selectedCountry = userProfile.country
        self.callUpdatePreferencesWebApi()
        self.exploreTableView.estimatedRowHeight = 70;
        self.exploreTableView.rowHeight = UITableViewAutomaticDimension
        self.exploreTableView.emptyDataSetSource = self;
        self.exploreTableView.emptyDataSetDelegate = self;
        
        self.headerCountryLbl.text = settingPreferences.country
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapOnCountryAction(_:)))
        headerCountryLbl.addGestureRecognizer(tapGesture)
        
        countryTableView.contentInset = UIEdgeInsetsMake(kWindowHeight()/2, 0, kWindowHeight()/2, 0)
        
    }
    
    //MARK:- IBAction Methods
    
    func tapOnCountryAction(_ tap: UITapGestureRecognizer ) {
        
        countryTableView.isHidden = false
    }

    @IBAction func crossButtonAction(_ sender: UIButton){
       // countryTableView.isHidden = false
        
        let countryVC = storyboardForName(name: "Discover").instantiateViewController(withIdentifier: "TDCountryVC") as! TDCountryVC
        countryVC.delegate = self
        countryVC.setContentSize()
        
        popUp = STPopupController(rootViewController: countryVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.navigationBarHidden = true
        popUp.containerView.layer.cornerRadius = 5
        popUp.containerView.clipsToBounds = true
       // popUp.delegate = self
        popUp.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
       // popUp.backgroundView.backgroundColor = UIColor.clear
        popUp.transitionStyle = .fade
        
        
        popUp.present(in: kAppDelegate.navController)
        
        let editButton = UIButton(frame: CGRect(x: (kWindowWidth()-40)/2, y: kWindowHeight()-90, width: 40, height: 40))
        editButton.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
        editButton.setImage(UIImage(named: "whitePassIcon"), for: .normal)
        popUp.backgroundView.addSubview(editButton)
        
        let arrowImage = UIImageView(frame: CGRect(x:(kWindowWidth()-15)/2, y: 115, width: 15, height: 10))
        arrowImage.image = UIImage(named:"upArrow")
        popUp.backgroundView.addSubview(arrowImage)
        popUp.backgroundView.sendSubview(toBack: arrowImage)
    }
    
    func dismissPopup(){
        popUp.dismiss()
    }
    
    // MARK:- Country Selected Delegate Methods
    
    func selectedCountry(country: String) {
        
        selectedCountry = country
        settingPreferences.strSearch = "country"
        settingPreferences.country = country
        self.callUpdatePreferencesWebApi()

    }


    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tableView == countryTableView {
            return countryList.count
        }else{
            return self.discoverDataList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if tableView == countryTableView {
            
            let cell:CountryTableCell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell", for: indexPath) as! CountryTableCell
            cell.selectionStyle = .none
            let obj = countryList.object(at: indexPath.row) as! TDCountryList
            cell.countryLbl.text = obj.countryName
            return cell
            
        }else{
            let cell:TDDiscoverCell = tableView.dequeueReusableCell(withIdentifier: "TDDiscoverCell", for: indexPath) as! TDDiscoverCell
            cell.selectionStyle = .none
            
            let discoverObj = self.discoverDataList.object(at: indexPath.row) as! TDDiscoverList
            
            cell.avtarImgView.sd_setImage(with: discoverObj.lastJournalPic, completed: { (image, error, type, url) in })
            cell.avtarImgView.backgroundColor = UIColor.red
            cell.likeBtn.isHidden = true
            cell.countLbl.text = discoverObj.journalCount;
            cell.genderLbl.text = (discoverObj.gender == "1") ? "M" : "F"
            if (discoverObj.work.length>0) {
                cell.ageLbl.text = "\(discoverObj.work), \(discoverObj.country)"
            }else{
                cell.ageLbl.text = discoverObj.country
            }
            let boldDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontBoldWithSize(17) ]
            let aAttrString = NSMutableAttributedString(string: discoverObj.username, attributes: ((boldDict as AnyObject) as! [String : Any]))
            let regularDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontRegularWithSize(17) ]
            let bAttrString = NSMutableAttributedString(string: ", \(discoverObj.age)", attributes: ((regularDict as AnyObject) as! [String : Any]))
            aAttrString.append(bAttrString)
            cell.nameLbl.attributedText = aAttrString
            
            //        if tableView.to_scrollBar != nil {
            //            cell.layoutMargins = (tableView.to_scrollBar?.adjustedTableViewCellLayoutMargins(forMargins: cell.layoutMargins, manualOffset: 0.0))!
            //        }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if tableView == exploreTableView {
            return 25.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: 25))
        titleLbl.textAlignment = .center
        titleLbl.font = kAppFontBoldWithSize(14)
        titleLbl.textColor = RGBA(255.0, g: 0.0, b: 88.0, a: 1.0)
        titleLbl.backgroundColor = UIColor.white
        titleLbl.text = selectedCountry
        return titleLbl
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if tableView == countryTableView {
            return 50
        }else{
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if tableView == countryTableView {
            
            let cell = tableView.cellForRow(at: indexPath) as! CountryTableCell
            selectedCountry = cell.countryLbl.text!
            settingPreferences.strSearch = "country"
            settingPreferences.country = cell.countryLbl.text!
            self.callUpdatePreferencesWebApi()
            countryTableView.isHidden = true
        }
        
    }
    
    //MARK:- DZNEmptyDataSetSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes = NSMutableDictionary();
        attributes[NSFontAttributeName] = kAppFontMediumWithSize(24)
        attributes[NSForegroundColorAttributeName] = UIColor.lightGray
        let aAttrString = NSMutableAttributedString(string: "NO EXPLORE YET \n CHECK BACK SOON", attributes: ((attributes as AnyObject) as! [String : Any]))
        return aAttrString;
    }
    
    //MARK:- Web Service Method For Login
    
    func callUpdatePreferencesWebApi(){
        
        let dictParam = NSMutableDictionary();
        dictParam[Kradius] = Int(settingPreferences.strRadius)
        dictParam[KRadiusUnit] = settingPreferences.strRadiusUnit
        dictParam[Ksearch] = settingPreferences.strSearch
        dictParam[Kcountry] = settingPreferences.country
        ServiceHelper.callAPIWithParameters(dictParam, method: .post, apiName: kUserPreference) { (result, error) in
            
            if self.getServiceResponseStatus(dict: result!) {
                self.makeWebApiGetSettingsInfo()
            }
        }
    }
    
    func makeWebApiGetSettingsInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kUserPreference) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if self.getServiceResponseStatus(dict: result!) {
                    
                    self.objPreferences =  TDUserPreferences.modelFromDict((dic.validatedValue(KPreference, expected: "" as AnyObject) as! Dictionary<String, AnyObject>))
                    self.makeApiCallToSearchWithText(string: settingPreferences.strSearch)
                }
            }
        }
    }
    
    func makeApiCallToSearchWithText(string:String){
        
        let dictParam = NSMutableDictionary();
        dictParam[KsearchType] = string
        
        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kUserSearch) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if self.getServiceResponseStatus(dict: result!) {
                    
                    self.discoverDataList.removeAllObjects()
                    self.discoverDataList = TDDiscoverList.modelFromDict(dic)
                    
//                    if self.discoverDataList.count > 5
//                    {
//                        let scrollBar = TOScrollBar()
//                        self.exploreTableView.to_add(scrollBar)
//                        self.exploreTableView.separatorInset = scrollBar.adjustedTableViewSeparatorInset(forInset: self.exploreTableView.separatorInset)
//                    }
                    self.exploreTableView.reloadData()
                }
            }
        }
    }
    
    
    func getServiceResponseStatus(dict:AnyObject) -> Bool {
        
        if let dic = dict as? Dictionary<String, AnyObject> {
            
            if let status = dic["success"] as? Bool {
                
                return status
            }
        }
        return false
    }
    
    //MARK:- Memory Warning Methods
    
//    deinit {
//        
//        if self.exploreTableView.to_scrollBar != nil {
//            self.exploreTableView.to_scrollBar?.removeFromScrollView()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
