//
//  TDActivityVC.swift
//  Qismet
//
//  Created by Suresh patel on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

enum ActivityType {
    case impressions, matches, history
}

class TDActivityVC: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,STPopupPreviewRecognizerDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate
{

    @IBOutlet weak var activityTableView: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var navBar: UIView!
    
    var activityType : ActivityType = .impressions
    var objPreferences : TDUserPreferences!
    var screenType = ""
    var discoverDataList = NSMutableArray()
    var passedDataList = NSMutableArray()
    var egoTableHeader:EGORefreshTableHeaderView!
     var isRefreshing: Bool = false
   // var loadView:LoadMoreTableFooterView!
    
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Class Helper Methods
    
    func setupDefaults(){
        
        switch activityType {
        case .impressions:
            screenType = "MESSAGES"
            titleLbl.text = "Messages"
            break
            
        case .matches:
            screenType = "MATCHES"
            titleLbl.text = "Matches"
            break
            
        default:
            settingPreferences.historySearch = "mylikes"
            self.callUpdatePreferencesWebApiWithText(string: settingPreferences.historySearch)
            screenType = "HISTORY"
            titleLbl.text = "History"
            break
        }
        self.view.layoutIfNeeded()
        self.activityTableView.estimatedRowHeight = 70;
        self.activityTableView.rowHeight = UITableViewAutomaticDimension
        self.activityTableView.emptyDataSetSource = self;
        self.activityTableView.emptyDataSetDelegate = self;
        
        egoTableHeader = EGORefreshTableHeaderView.init(frame: CGRect(x: 0.0, y: 0.0 - self.activityTableView.bounds.size.height, width: kWindowWidth(), height: self.activityTableView.bounds.size.height))
        egoTableHeader.delegate = self
        self.activityTableView.addSubview(egoTableHeader)
        
        egoTableHeader.refreshLastUpdatedDate()

        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        let color1 = RGBA(209.0, g: 103.0, b: 57.0, a: 1.0)
//        let color2 = RGBA(186.0, g: 53.0, b: 107.0, a: 1.0)
//        gradient.colors = [color1.cgColor, color2.cgColor]
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        navBar.layer.insertSublayer(gradient, at: 0)
        
        
        
    }
    
    
    //MARK:- UITableView Delegate and DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if activityType == .history {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if activityType == .history && section == 0 {
            return passedDataList.count
        }
        return discoverDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:TDDiscoverCell = tableView.dequeueReusableCell(withIdentifier: "TDDiscoverCell", for: indexPath) as! TDDiscoverCell
        cell.selectionStyle = .none
        
        if (cell.popupPreviewRecognizer == nil) {
            cell.popupPreviewRecognizer = STPopupPreviewRecognizer.init(delegate: self)
        }
        var activityObj = TDDiscoverList()
        if activityType == .history && indexPath.section == 0 {
            activityObj = self.passedDataList.object(at: indexPath.row) as! TDDiscoverList
        }else{
            activityObj = self.discoverDataList.object(at: indexPath.row) as! TDDiscoverList
        }
        cell.objDiscover = activityObj
        cell.avtarImgView.sd_setImage(with: activityObj.lastJournalPic, completed: { (image, error, type, url) in })
        cell.avtarImgView.backgroundColor = UIColor.red
        cell.countLbl.text = activityObj.journalCount;
        cell.genderLbl.text = (activityObj.gender == "1") ? "M" : "F"
        if (activityObj.work.length>0) {
            cell.ageLbl.text = "\(activityObj.work), \(activityObj.country)"
        }else{
            cell.ageLbl.text = activityObj.country
        }
        let boldDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontBoldWithSize(17) ]
        let aAttrString = NSMutableAttributedString(string: activityObj.username, attributes: ((boldDict as AnyObject) as! [String : Any]))
        let regularDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontRegularWithSize(17) ]
        let bAttrString = NSMutableAttributedString(string: ", \(activityObj.age)", attributes: ((regularDict as AnyObject) as! [String : Any]))
        aAttrString.append(bAttrString)
        cell.nameLbl.attributedText = aAttrString
        
        if (activityObj.likes) {
            cell.likeBtn.setImage(UIImage(named:"heartWhite"), for: .normal)
        }else{
            cell.likeBtn.setImage(UIImage(named:"whitePassIcon"), for: .normal)
        }
        
//        if tableView.to_scrollBar != nil {
//            cell.layoutMargins = (tableView.to_scrollBar?.adjustedTableViewCellLayoutMargins(forMargins: cell.layoutMargins, manualOffset: 0.0))!
//        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if activityType == .history {
            if section == 0 && self.passedDataList.count > 0 {
                return 25.0
            }
            if section == 1 && self.discoverDataList.count > 0 {
                return 25.0
            }
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: 25))
        titleLbl.textAlignment = .center
        titleLbl.font = kAppFontBoldWithSize(14)
        titleLbl.textColor = RGBA(255.0, g: 0.0, b: 88.0, a: 1.0)
        titleLbl.backgroundColor = UIColor.white
        if section == 0 {
            titleLbl.text = "P A S S E D"
        }else{
            titleLbl.text = "L I K E S"
        }
        return titleLbl
    }
    
    //MARK:- DZNEmptyDataSetSource Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes = NSMutableDictionary();
        attributes[NSFontAttributeName] = kAppFontMediumWithSize(24)
        attributes[NSForegroundColorAttributeName] = UIColor.lightGray
        let aAttrString = NSMutableAttributedString(string: "NO \(self.screenType) YET \n CHECK BACK SOON", attributes: ((attributes as AnyObject) as! [String : Any]))
        return aAttrString;
    }
    
    //MARK:- EGOTableHeader Delegate Methods
    
    func egoRefreshTableHeaderDidTriggerRefresh(_ view: EGORefreshTableHeaderView!) {
        
        isRefreshing = true
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            // waiting for loading data from internet
            sleep(3)
            DispatchQueue.main.sync(execute: {() -> Void in
                // complete refreshing
                self.isRefreshing = false
                self.activityTableView.reloadData()
                self.egoTableHeader.egoRefreshScrollDataSourceDidFinishedLoading(self.activityTableView)
            })
        })

    }
    
    func egoRefreshTableHeaderDataSourceIsLoading(_ view: EGORefreshTableHeaderView!) -> Bool {
        return isRefreshing
    }
    
    func egoRefreshTableHeaderDataSourceLastUpdated(_ view: EGORefreshTableHeaderView!) -> Date! {
        return Date()
    }
    
    //MARK:- UIButton Action
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
//        let notificationName = Notification.Name("CameraWillAppear")
//        NotificationCenter.default.post(name: notificationName, object: nil)
//
//        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
//        loginVC.snapchatSwipeContainer.scrollView.setContentOffset(CGPoint(x: kWindowWidth(), y: 0.0), animated: true)
    }
    
    
    //MARK:- STPopUpPagePreview Delegate Methods
    
    func previewViewController(for popupPreviewRecognizer: STPopupPreviewRecognizer!) -> UIViewController! {
        
        if !(popupPreviewRecognizer.view is TDDiscoverCell) {
            return nil
        }
        let cell = popupPreviewRecognizer.view as! TDDiscoverCell
        
        let popVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDProfilePopUp") as! TDProfilePopUp
        popVC.setContentSize()
        popVC.isFromDiscover = true
        popVC.objDiscover = cell.objDiscover
        
        return popVC

    }
    
    func presentingViewController(for popupPreviewRecognizer: STPopupPreviewRecognizer!) -> UIViewController! {
        
        popupPreviewRecognizer.popupController.navigationBarHidden = true
        return self
    }
    
    func previewActions(for popupPreviewRecognizer: STPopupPreviewRecognizer!) -> [STPopupPreviewAction]! {
        
        let cell = popupPreviewRecognizer.view as! TDDiscoverCell
        
        if cell.objDiscover.likes {
            
            return [STPopupPreviewAction.init(title: "Pass", style: .destructive, handler: {( _ action: STPopupPreviewAction?, _ previewViewController: UIViewController?) -> Void in
                
                
            }) ]
        }else{
            
            return [STPopupPreviewAction.init(title: "Like", style: .default, handler: {( _ action: STPopupPreviewAction?, _ previewViewController: UIViewController?) -> Void in
                
                
            }) ]
        }
        
    }
    
    //MARK:- Scroll View Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        egoTableHeader.egoRefreshScrollDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        egoTableHeader.egoRefreshScrollDidEndDragging(scrollView)
    }
    
    
    //MARK:- Web Service Method For Login
    
    func callUpdatePreferencesWebApiWithText(string:String){
        
        let dictParam = NSMutableDictionary();
        dictParam[Kradius] = Int(settingPreferences.strRadius)
        dictParam[KRadiusUnit] = settingPreferences.strRadiusUnit
        dictParam[Ksearch] = settingPreferences.strSearch
        dictParam[Kcountry] = settingPreferences.country
        dictParam[KHistorySearch] = string

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
                    self.makeApiCallToSearchWithText(string: settingPreferences.historySearch)
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
                    
                    if string == "mylikes" {
                        self.discoverDataList.removeAllObjects()
                        self.discoverDataList = TDDiscoverList.modelFromDict(dic)
                        settingPreferences.historySearch = "passed"
                        self.callUpdatePreferencesWebApiWithText(string: settingPreferences.historySearch)
                    }
                    else if string == "passed"{
                        
//                        self.discoverDataList.insert(TDDiscoverList.modelFromDict(dic) as [AnyObject], at: NSIndexSet(indexesIn: NSMakeRange(0, TDDiscoverList.modelFromDict(dic).count)) as IndexSet)
                        self.passedDataList.removeAllObjects()
                        self.passedDataList = TDDiscoverList.modelFromDict(dic)
                        
                        self.activityTableView.reloadData()
                        
                    }
                    
//                    if self.discoverDataList.count > 5
//                    {
//                        let scrollBar = TOScrollBar()
//                        self.activityTableView.to_add(scrollBar)
//                        self.activityTableView.separatorInset = scrollBar.adjustedTableViewSeparatorInset(forInset: self.activityTableView.separatorInset)
//                    }
                    

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
//        if self.activityTableView.to_scrollBar != nil {
//            self.activityTableView.to_scrollBar?.removeFromScrollView()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
