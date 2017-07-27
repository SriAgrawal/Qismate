//
//  TDDiscoverVC.swift
//  Qismet
//
//  Created by Suresh patel on 20/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

enum DiscoverType {
    case featured, newest, dist
}

class TDDiscoverVC: UIViewController, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,EGORefreshTableHeaderDelegate {

    @IBOutlet weak var discoverTableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var discoverType : DiscoverType = .featured
    var objPreferences : TDUserPreferences!
    var screenType = ""
    var discoverDataList = NSMutableArray()
    var popUp : STPopupController!
    var likeBtn: UIButton!
    var passBtn: UIButton!
    var objSelectedUser = TDDiscoverList()
    
    var isRefreshing: Bool = false
    
    var egoTableHeader:EGORefreshTableHeaderView!
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
        // Do any additional setup after loading the view.
    }
    

    //MARK:- Class Helper Methods

    func setupDefaults(){
        
        switch discoverType {
        case .featured:
            screenType = "FEATURED"
            break
            
        case .newest:
            settingPreferences.strSearch = "anywhere"
            self.callUpdatePreferencesWebApi()
            screenType = "NEWEST"
            titleLbl.text = "Discover"

            break

        default:
            settingPreferences.strSearch = "local"
            self.callUpdatePreferencesWebApi()
            screenType = "DISTANCE"
            titleLbl.text = "Nearby"
            break
        }
        
        self.view.layoutIfNeeded()
        self.discoverTableView.estimatedRowHeight = 70;
        self.discoverTableView.rowHeight = UITableViewAutomaticDimension
        self.discoverTableView.emptyDataSetSource = self;
        self.discoverTableView.emptyDataSetDelegate = self;
        
        egoTableHeader = EGORefreshTableHeaderView.init(frame: CGRect(x: 0.0, y: 0.0 - self.discoverTableView.bounds.size.height, width: kWindowWidth(), height: self.discoverTableView.bounds.size.height))
        egoTableHeader.delegate = self
        self.discoverTableView.addSubview(egoTableHeader)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.discoverDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:TDDiscoverCell = tableView.dequeueReusableCell(withIdentifier: "TDDiscoverCell", for: indexPath) as! TDDiscoverCell
        cell.selectionStyle = .none
        
        let discoverObj = self.discoverDataList.object(at: indexPath.row) as! TDDiscoverList
        cell.objDiscover = discoverObj
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = tableView.cellForRow(at: indexPath) as! TDDiscoverCell
        self.showProfilePopUp(cell.objDiscover)
    }
    
    func showProfilePopUp(_ obj: TDDiscoverList) {
        
        let popVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDProfilePopUp") as! TDProfilePopUp
        popVC.setContentSize()
        popVC.isFromDiscover = true
        popVC.objDiscover = obj
        objSelectedUser = obj
        
        popUp = STPopupController(rootViewController: popVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.navigationBarHidden = true
        popUp.containerView.layer.cornerRadius = 5
        popUp.containerView.clipsToBounds = true
        
        if discoverType == .newest {
            
            likeBtn = UIButton.init(frame: CGRect(x: (kWindowWidth()-40)/2+50, y:  kWindowHeight()-100, width: 40, height: 40))
            likeBtn.setImage(UIImage(named: "likeIcon"), for: .normal)
            likeBtn.addTarget(self, action: #selector(likeBtnAction(button:)), for: .touchUpInside)
            popUp.backgroundView.addSubview(likeBtn)
            
            passBtn = UIButton.init(frame: CGRect(x: (kWindowWidth()-40)/2-50, y:  kWindowHeight()-100, width: 40, height: 40))
            passBtn.setImage(UIImage(named: "passIcon"), for: .normal)
            passBtn.addTarget(self, action: #selector(passBtnAction(button:)), for: .touchUpInside)
            popUp.backgroundView.addSubview(passBtn)

        }

        popUp.present(in: self)
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
                self.discoverTableView.reloadData()
                self.egoTableHeader.egoRefreshScrollDataSourceDidFinishedLoading(self.discoverTableView)
            })
        })
    }
    
    func egoRefreshTableHeaderDataSourceIsLoading(_ view: EGORefreshTableHeaderView!) -> Bool {
        return isRefreshing
    }
    
    func egoRefreshTableHeaderDataSourceLastUpdated(_ view: EGORefreshTableHeaderView!) -> Date! {
        return Date()
    }
    
    //MARK:- Scroll View Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        egoTableHeader.egoRefreshScrollDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        egoTableHeader.egoRefreshScrollDidEndDragging(scrollView)
    }
    
    //MARK:- UIButton Action
    
    func likeBtnAction(button: UIButton) {
        
        FlareView.sharedCenter().flarify(likeBtn, inParentView: popUp.backgroundView, with: RGBA(255, g: 0, b: 88, a: 1.0))
        self.perform(#selector(callLikeAPI), with: nil, afterDelay: 1.8)
        
    }
    
    func passBtnAction(button: UIButton) {
        
        FlareView.sharedCenter().flarify(passBtn, inParentView: popUp.backgroundView, with: UIColor.white)
        self.perform(#selector(callPassAPI), with: nil, afterDelay: 1.8)
    }
    
    func callLikeAPI() {
        self.makeApiCallToLikeUserDataWithStatus(string:"L", friendId: objSelectedUser.userId)
    }
    
    func callPassAPI() {
        self.makeApiCallToLikeUserDataWithStatus(string:"P", friendId: objSelectedUser.userId)
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
                    
                    self.discoverDataList.removeAllObjects()
                    self.discoverDataList = TDDiscoverList.modelFromDict(dic)
                    self.discoverTableView.reloadData()

//                    if self.discoverDataList.count > 5
//                    {
//                        let scrollBar = TOScrollBar()
//                        self.discoverTableView.to_add(scrollBar)
//                        self.discoverTableView.separatorInset = scrollBar.adjustedTableViewSeparatorInset(forInset: self.discoverTableView.separatorInset)
//                    }

                }
            }
        }
    }
    
    func makeApiCallToLikeUserDataWithStatus(string:String, friendId:String){
        
        let dictParam = NSMutableDictionary();
        dictParam[KFriendId] = Int(friendId)
        dictParam[KlikeFlag] = string
        dictParam[Kcomplement] = ""
        
        ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kLikeFriend) { (result, error) in
            
            if self.getServiceResponseStatus(dict: result!) {
                
                for item in self.discoverDataList{
                    let obj = item as! TDDiscoverList
                    if obj.userId == friendId{
                        self.discoverDataList.remove(item)
                        break;
                    }
                }
                self.discoverTableView.reloadData()
                self.popUp.dismiss()
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
//        if self.discoverTableView.to_scrollBar != nil {
//            self.discoverTableView.to_scrollBar?.removeFromScrollView()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
