//
//  TDSearchVC.swift
//  Qismet
//
//  Created by Suresh patel on 22/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var discoverDataList = NSMutableArray()
    var searchedDataList = [TDDiscoverList]()
    var isDismiss = false
    
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let textField = searchBar.value(forKey: "_searchField") as! UITextField
        textField.clearButtonMode = .never;
    }

    //MARK:- Class Helper Methods
    
    func setupDefaults(){
        
       // self.searchBar.becomeFirstResponder()
        self.searchTableView.estimatedRowHeight = 70;
        self.searchTableView.rowHeight = UITableViewAutomaticDimension
        self.callUpdatePreferencesWebApi()
    }
    
    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.searchedDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:TDDiscoverCell = tableView.dequeueReusableCell(withIdentifier: "TDDiscoverCell", for: indexPath) as! TDDiscoverCell
        cell.selectionStyle = .none
        
        let discoverObj = self.searchedDataList[indexPath.row]
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.isTracking){
            isDismiss = false
            if scrollView.contentOffset.y < -100 {
                isDismiss = true
            }
        }
        else if isDismiss{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //MARK:- UISearchBar Delegate Method

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.length == 0 {
            self.searchedDataList.removeAll()
        }
        else{
            self.searchedDataList.removeAll()
            self.searchedDataList = self.discoverDataList.filtered(using: NSPredicate(format: "username contains[c] %@", searchText)) as! [TDDiscoverList]
        }
        
        self.searchTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
       // self.dismiss(animated: false, completion: nil)
        self.view.endEditing(true)
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
            
            if self.getServiceResponseStatus(dict: result!) {
                
                self.makeApiCallToSearchWithText(string: settingPreferences.strSearch)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
