//
//  TDProfilePopUp.swift
//  Qismet
//
//  Created by Lalit on 14/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TDProfilePopUp: UIViewController,UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var coverImgview: UIImageView!
    @IBOutlet weak var coverBtn: UIButton!
    
    @IBOutlet weak var avtarImgview: UIImageView!
    @IBOutlet weak var avtarBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var snapchatBtn: UIButton!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var popTblView: UITableView!
    @IBOutlet weak var popMapView: MKMapView!
    @IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var popTableViewBottomConstraint: NSLayoutConstraint!
    
    
    var objProfile = TDUserList()
    var objDiscover = TDDiscoverList()
    var isFromDiscover: Bool = false
    var tableDataArray = NSMutableArray()
    
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDefaults()

    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults() {
        
        if isFromDiscover {
            self.setDiscoverView()
        }else{
            self.makeWebApiGetProfileWithInfo()
        }
        
        avtarImgview.layer.cornerRadius = 40
        avtarImgview.clipsToBounds = true
        avtarImgview.layer.borderWidth = 1.0
        avtarImgview.layer.borderColor = UIColor.white.cgColor
        avtarBtn.layer.cornerRadius = 40
        avtarBtn.clipsToBounds = true
        
        avtarBtn.isExclusiveTouch = true
        instagramBtn.isExclusiveTouch = true
        snapchatBtn.isExclusiveTouch = true
        verifyBtn.isExclusiveTouch = true
        coverBtn.isExclusiveTouch = true

        popTblView.delegate = self
        popTblView.dataSource = self
        popTblView.rowHeight = UITableViewAutomaticDimension
        popTblView.estimatedRowHeight = 10
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapOnlocation))
        ageLbl.addGestureRecognizer(tap)
        
        let tapCover = UITapGestureRecognizer(target: self, action:#selector(tapOnCover))
        coverImgview.addGestureRecognizer(tapCover)

        avtarBtn.addTarget(self, action: #selector(tapOnAvtar), for: .touchUpInside)

    }
    
    func setContentSize(){
        self.contentSizeInPopup = CGSize(width: kWindowWidth()-80, height: 380)
    }
    
    func tapOnlocation()  {
        popMapView.isHidden = !popMapView.isHidden
    }
    
    func tapOnCover()  {
        SCAvatarBrowser.show(coverImgview, "cover")
    }
    
    func tapOnAvtar() {
        SCAvatarBrowser.show(avtarImgview, "avtar")
    }
    
    func setInitialView(){
        
        coverImgview.sd_setImage(with: objProfile.profilePicUrl)
        avtarImgview.sd_setImage(with: objProfile.avtarImgUrl)
        
        let boldDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontBoldWithSize(17) ]
        let aAttrString = NSMutableAttributedString(string: objProfile.firstName, attributes: ((boldDict as AnyObject) as! [String : Any]))
        let regularDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontRegularWithSize(17) ]
        let bAttrString = NSMutableAttributedString(string: ", \(objProfile.age)", attributes: ((regularDict as AnyObject) as! [String : Any]))
        aAttrString.append(bAttrString)
        usernameLbl.attributedText = aAttrString
        
        ageLbl.text = objProfile.address
        
        if objProfile.instagramId.length > 0 {
            instagramBtn.isHidden = false
        }else{
            instagramBtn.isHidden = true
        }
        
        if objProfile.snapchatId.length > 0 {
            snapchatBtn.isHidden = false
        }else{
            snapchatBtn.isHidden = true
        }
        self.verifyBtn.isHidden = false

        var str: String = "@\(objProfile.userName)"
        if objProfile.occupation.length > 0 {
            
            if objProfile.isShowWork {
                str = "\(str), \(objProfile.occupation)"
            }
        }
        if objProfile.education.length > 0 {
            if objProfile.education.range(of:",") != nil {
                objProfile.education = objProfile.education.components(separatedBy: ",")[0]
            }
            
            if objProfile.isShowSchool {
                str = "\(str), \(objProfile.education)"
            }
            
            if str.length > 0 {
                let obj = TDTagList()
                obj.data = str
                tableDataArray.add(obj)
            }
        }
        
//        if objProfile.interest.length > 0 {
//            let obj = TDTagList()
//            obj.data = objProfile.interest
//            obj.heading = "ABOUT"
//            tableDataArray.add(obj)
//        }
        
        if objProfile.tags.length > 0 {
            let obj = TDTagList()
            obj.data = objProfile.tags
            obj.heading = "ABOUT"
            tableDataArray.add(obj)
        }
        self.popTblView.reloadData()
        
      //  let coordinates:CLLocationCoordinate2D = self.geoCode(usingAddress: (ageLbl.text)!)
        
        let address = ageLbl.text
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                let coordinate:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let point = MKPointAnnotation()
                point.coordinate = coordinate
                point.title = self.objProfile.country
                self.popMapView.addAnnotation(point)
                
                self.popMapView.setCenter(coordinate, animated: true)
                
                var region = MKCoordinateRegion()
                region.center.latitude = coordinate.latitude
                region.center.longitude = coordinate.longitude
                region.span.longitudeDelta = 1.99
                region.span.latitudeDelta = 1.99
                self.popMapView.setRegion(region, animated: true)
                
            }
        })
    }
    
    func setDiscoverView(){
        
        coverImgview.sd_setImage(with: objDiscover.profilePicUrl)
        avtarImgview.sd_setImage(with: objDiscover.avtarImgUrl)
        
        let boldDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontBoldWithSize(17) ]
        let aAttrString = NSMutableAttributedString(string: objDiscover.username, attributes: ((boldDict as AnyObject) as! [String : Any]))
        let regularDict: [AnyHashable: Any] = [ NSFontAttributeName : kAppFontRegularWithSize(17) ]
        let bAttrString = NSMutableAttributedString(string: ", \(objDiscover.age)", attributes: ((regularDict as AnyObject) as! [String : Any]))
        aAttrString.append(bAttrString)
        usernameLbl.attributedText = aAttrString
        
        ageLbl.text = objDiscover.address
        
        if objDiscover.instagramId.length > 0 {
            instagramBtn.isHidden = false
        }else{
            instagramBtn.isHidden = true
        }
        
        if objDiscover.snapchatId.length > 0 {
            snapchatBtn.isHidden = false
        }else{
            snapchatBtn.isHidden = true
        }
        
        var str: String = "@\(objDiscover.username)"
        if objDiscover.work.length > 0 {
            str = "\(str), \(objDiscover.work)"
        }
        if objDiscover.education.length > 0 {
            if objDiscover.education.range(of:",") != nil {
                objDiscover.education = objDiscover.education.components(separatedBy: ",")[0]
            }
            str = "\(str), \(objDiscover.education)"
            if str.length > 0 {
                let obj = TDTagList()
                obj.data = str
                tableDataArray.add(obj)
            }
        }
        
        if objDiscover.tagLine.length > 0 {
            let obj = TDTagList()
            obj.data = objDiscover.tagLine
            obj.heading = "ABOUT"
            tableDataArray.add(obj)
        }
        
        if objDiscover.tagsString.length > 0 {
            let obj = TDTagList()
            obj.data = objDiscover.tagsString
            obj.heading = "INTERESTS"
            tableDataArray.add(obj)
        }
        self.popTblView.reloadData()
        
        //  let coordinates:CLLocationCoordinate2D = self.geoCode(usingAddress: (ageLbl.text)!)
        
        let address = ageLbl.text
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                let coordinate:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let point = MKPointAnnotation()
                point.coordinate = coordinate
                point.title = self.objDiscover.country
                self.popMapView.addAnnotation(point)
                
                self.popMapView.setCenter(coordinate, animated: true)
                
                var region = MKCoordinateRegion()
                region.center.latitude = coordinate.latitude
                region.center.longitude = coordinate.longitude
                region.span.longitudeDelta = 1.99
                region.span.latitudeDelta = 1.99
                self.popMapView.setRegion(region, animated: true)
            }
        })
    }

    
//    func geoCode(usingAddress address: String) -> CLLocationCoordinate2D {
//        
//        let address = address
//        let geocoder = CLGeocoder()
//        
//        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
//            if((error) != nil){
//                print("Error", error as Any)
//            }
//            if let placemark = placemarks?.first {
//                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
//                return coordinates
//            }
//        })
//    }
    
    //MARK:- UIButton Actions
    
    @IBAction func instagramBtnAction(_ sender: UIButton) {
        
        let strUrl = "http://www.instagram.com/\(objProfile.instagramId)"
        let instagramUrl:NSURL = NSURL.init(string: strUrl)!
        UIApplication.shared.openURL(instagramUrl as URL)

    }
    
    
    @IBAction func snapchatBtnAction(_ sender: UIButton) {
        
        let strUrl = "https://www.snapchat.com/add/\(objProfile.snapchatId)"
        let snapchatUrl:NSURL = NSURL.init(string: strUrl)!
        UIApplication.shared.openURL(snapchatUrl as URL)
    }
    
    
    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:PopUpTableCell = tableView.dequeueReusableCell(withIdentifier: "PopUpTableCell", for: indexPath) as! PopUpTableCell
        cell.sepLbl.isHidden = true;

        let obj = tableDataArray.object(at: indexPath.row) as! TDTagList
        if indexPath.row == 0 {
            cell.dataLblTopConstraint.constant = 2
            cell.dataLbl.text = obj.data
            cell.headingLbl.text = ""
        }else{
            cell.dataLblTopConstraint.constant = 35
            cell.dataLbl.text = obj.data
            cell.headingLbl.text = obj.heading
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return popTblView.rowHeight
    }
    
    
    //MARK:- UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if scrollView == popTblView {
            arrowBtn.isHidden = true
            popTableViewBottomConstraint.constant = 7
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        if scrollView == popTblView {
            if scrollView.contentOffset.y == 0.0 {
                arrowBtn.isHidden = false
                popTableViewBottomConstraint.constant = 27
            }
        }
    }
    
    //MARK:- Web Service Method For get Profile Data
    
    func makeWebApiGetProfileWithInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kviewUserProfile) { (result, error) in
            
            self.objProfile = TDUserList.modelFromDict(result as? Dictionary<String, AnyObject>)
            self.setInitialView()
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
