//
//  TDMomentsVC.swift
//  Qismet
//
//  Created by Suresh patel on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

enum MomentsType {
    case featured, recent, dist
}

class TDMomentsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var momentsCollectionView: UICollectionView!
    var screenType = ""
    var momentType : MomentsType = .featured
    var objPreferences : TDUserPreferences!
    var momentDataList = NSMutableArray()
    
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Class Helper Methods
    
    func setupDefaults(){
        
        switch momentType {
        case .featured:
            screenType = "FEATURED"
            break
            
        case .recent:
            settingPreferences.strSearch = "anywhere"
            self.callUpdatePreferencesWebApi()
            screenType = "RECENT"
            break
            
        default:
            settingPreferences.strSearch = "local"
            self.callUpdatePreferencesWebApi()
            screenType = "DISTANCE"
            break
        }
        
        self.momentsCollectionView.emptyDataSetSource = self;
        self.momentsCollectionView.emptyDataSetDelegate = self;
    }
    
    //MARK:- UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.momentDataList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDMomentsCell", for: indexPath) as! TDMomentsCell
        
        let momentsObj = self.momentDataList.object(at: indexPath.row) as! TDDiscoverList
        cell.backgroundImageView.sd_setImage(with: momentsObj.lastJournalPic)
        cell.dateLbl.text = momentsObj.lastJournalDate;
        cell.locationLbl.text = momentsObj.lastJournalLocation.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
        
//        if collectionView.to_scrollBar != nil {
//            cell.layoutMargins = (collectionView.to_scrollBar?.adjustedTableViewCellLayoutMargins(forMargins: cell.layoutMargins, manualOffset: 0.0))!
//        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: (kWindowWidth() - 20)/3, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    //MARK:- DZNEmptyDataSetSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes = NSMutableDictionary();
        attributes[NSFontAttributeName] = kAppFontMediumWithSize(24)
        attributes[NSForegroundColorAttributeName] = UIColor.lightGray
        let aAttrString = NSMutableAttributedString(string: "NO \(self.screenType) YET \n CHECK BACK SOON", attributes: ((attributes as AnyObject) as! [String : Any]))
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
                    
                    self.momentDataList.removeAllObjects()
                    self.momentDataList = TDDiscoverList.modelFromDict(dic)
                    
//                    if self.momentDataList.count > 5
//                    {
//                        let scrollBar = TOScrollBar()
//                        self.momentsCollectionView.to_add(scrollBar)
//                    }
                    self.momentsCollectionView.reloadData()
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
//        if self.momentsCollectionView.to_scrollBar != nil {
//            self.momentsCollectionView.to_scrollBar?.removeFromScrollView()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
