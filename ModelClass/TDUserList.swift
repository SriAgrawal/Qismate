//
//  TDUserList.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDUserList: NSObject {
    
    var userName : String = ""
    var interest : String = ""
    var country : String = ""
    var email : String = ""
    var age : String = ""
    var strDistance : String = ""
    var strDistanceUnit : String = ""
    var sex : String = ""
    var userId : String = ""
    var avtarImgUrl : URL?
    var profilePicUrl : URL?
    var lastJournalPic : URL?
    var lastJournalText : String = ""
    var journalCount : String = ""
    var lastLocation : String = ""
    var journalTimestamp : String = ""
    var instagramId : String = ""
    var snapchatId : String = ""
    var tags : String = ""
    var selectedTagArray = [Any]()
    var hobbieTagArray = [Any]()
    var personalityTagArray = [Any]()
    var cityName : String = ""
    var stateName : String = ""
    var occupation : String = ""
    var address : String = ""
    var education : String = ""
    var firstName : String = ""
    var lastName : String = ""
    
    var isUsernameAvailable: Int = 0
    
    var isShowSchool: Bool = false
    var isShowWork: Bool = false
    var isEditSelected: Bool = false
    var isComplement: Bool = false
    var journalView: Bool = false
    
    var statusHeight: Float = 0.0
    var tagHeight: Float = 0.0
    var titleHeight: Float = 0.0
    var interestHeight: Float = 0.0

    
class func modelFromDict(_ infoDict:Dictionary<String, AnyObject>?) -> TDUserList {
    
    let obj = TDUserList()
    
    if let dicInfo = infoDict {
        
        let dic = (dicInfo.validatedValue(Kprofile, expected: "" as AnyObject)) as! Dictionary<String, AnyObject>
        obj.userName = "\(dic.validatedValue(Kusername, expected: "" as AnyObject))"
        obj.interest = "\((dic.validatedValue(KtagLine, expected: "" as AnyObject).removingPercentEncoding!)!)"
        obj.country = "\(dic.validatedValue(Kcountry, expected: "" as AnyObject))"
        obj.email = "\(dic.validatedValue(Kemail, expected: "" as AnyObject))"
        obj.journalView = (dic.validatedValue(KJournalViewed, expected: false as AnyObject) as! Bool)
        obj.age = "\(dic.validatedValue(Kage, expected: "" as AnyObject))"
        obj.userId = "\(dic.validatedValue(KuserId, expected: "" as AnyObject))"
        obj.cityName = "\(dic.validatedValue("city", expected: "" as AnyObject))"
        obj.stateName = "\(dic.validatedValue("state", expected: "" as AnyObject))"
        
        var countryCode = ""
        
        for item in countryList {
            let contryObj = item as! TDCountryList
            
            if obj.country == contryObj.countryName {
                
                countryCode = contryObj.countryCode
                break
            }
        }

        if obj.cityName.length>0 &&  obj.stateName.length>0 && obj.country.length>0{
            if (obj.country == "United States") {
                countryCode = "US";
            }
            obj.address = "\(obj.cityName), \(obj.stateName) (\(countryCode))"
        }else if obj.cityName.length>0 &&  obj.stateName.length>0{
            obj.address = "\(obj.cityName), \(obj.stateName)"
        }
        else if obj.cityName.length>0 &&  obj.country.length>0{
            if (obj.country == "United States") {
                countryCode = "US";
            }
            obj.address = "\(obj.cityName) (\(countryCode))"
        }
        else if obj.stateName.length>0 &&  obj.country.length>0{
            if (obj.country == "United States") {
                countryCode = "US";
            }
            obj.address = "\(obj.stateName) (\(countryCode))"
        }
        else{
            obj.address = obj.country
        }

        let str = "\(dic.validatedValue(Kgender, expected: "" as AnyObject))"
        if str == "1" {
            obj.sex = "Male"
        }else{
            obj.sex = "Female"
        }

        obj.instagramId = "\(dic.validatedValue(Kinstagram, expected: "" as AnyObject))"
        obj.snapchatId = "\(dic.validatedValue(KsnapchatId, expected: "" as AnyObject))"
        obj.profilePicUrl = URL(string: "\(dic.validatedValue(KprofileImage, expected: "" as AnyObject))") as URL!
        obj.avtarImgUrl = URL(string: "\(dic.validatedValue(KavtarImage, expected: "" as AnyObject))") as URL!
        obj.occupation = "\(dic.validatedValue("work", expected: "" as AnyObject))"
        obj.education = "\(dic.validatedValue("education", expected: "" as AnyObject))"
        obj.firstName = "\(dic.validatedValue("firstName", expected: "" as AnyObject))"
        obj.lastName = "\(dic.validatedValue("lastName", expected: "" as AnyObject))"
        obj.isShowWork = dic.validatedValue("showWork", expected: false as AnyObject) as! Bool
        obj.isShowSchool = dic.validatedValue("showSchool", expected: false as AnyObject) as! Bool
        obj.hobbieTagArray = dic.validatedValue(KHobbyTags, expected: NSArray() as AnyObject) as! [Any]
        obj.personalityTagArray = dic.validatedValue(KPersonalityTags, expected: NSArray() as AnyObject) as! [Any]
        obj.selectedTagArray = obj.hobbieTagArray + obj.personalityTagArray
        
        for item in obj.selectedTagArray {
            if obj.tags == "" {
                obj.tags = item as! String
            }else{
                let str = item as! String
                obj.tags = obj.tags + ", "+str
            }
        }
        
        let journalInfo = (dicInfo.validatedValue("latestJournal", expected: "" as AnyObject)) as! Dictionary<String, AnyObject>

        print(journalInfo.validatedValue("imageFile", expected: "" as AnyObject))
        obj.lastJournalText = "\(journalInfo.validatedValue(KJournalText, expected: "" as AnyObject))"
        obj.lastLocation = "\(journalInfo.validatedValue(Klocation, expected: "" as AnyObject))"
        obj.journalCount = "\(journalInfo.validatedValue(KJournalCount, expected: "" as AnyObject))"
        obj.lastJournalPic = URL(string: "\(journalInfo.validatedValue("imageFile", expected: "" as AnyObject))") as URL!

    }
    
    return obj
    
}
}
