//
//  TDDiscoverList.swift
//  Qismet
//
//  Created by Suresh patel on 22/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDDiscoverList: NSObject {

    var country : String = ""
    var education : String = ""
    var gender : String = ""
    var distance : String = ""
    var city : String = ""
    var tagLine : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var lastJournalText : String = ""
    var myLikes : String = ""
    var lastJournalLocation : String = ""
    var state : String = ""
    var avatarText : String = ""
    var work : String = ""
    var userId : String = ""
    var unit : String = ""
    var lastJournalDate : String = ""
    var journalCount : String = ""
    var lastJournalId : String = ""
    var age : String = ""
    var username : String = ""
    var tagsString : String = ""
    var instagramId : String = ""
    var snapchatId : String = ""
    var firstName : String = ""
    var address : String = ""

    var hobbyTags = [Any]()
    var personalityTags = [Any]()
    var tags = [Any]()

    var avtarImgUrl : URL?
    var profilePicUrl : URL?
    var lastJournalPic : URL?

    var journalViewed: Bool = false
    var likes: Bool = false
    var showWork: Bool = false
    var showSchool: Bool = false
    var online: Bool = false
    
    class func modelFromDict(_ dic:Dictionary<String, AnyObject>?) -> NSMutableArray {
        
        let userData = dic?.validatedValue("userData", expected: NSArray()) as! NSArray
        let userDataArray = NSMutableArray()
        
        for item in userData {
            
            let dicInfo = item as! Dictionary<String, AnyObject>
            let obj = TDDiscoverList()
            obj.country = "\(dicInfo.validatedValue(Kcountry, expected: "" as AnyObject))"
            obj.education = "\(dicInfo.validatedValue(Keducation, expected: "" as AnyObject))"
            obj.gender = "\(dicInfo.validatedValue(Kgender, expected: "" as AnyObject))"
            obj.distance = "\(dicInfo.validatedValue(Kdistance, expected: "" as AnyObject))"
            obj.city = "\(dicInfo.validatedValue(Kcity, expected: "" as AnyObject))"
            obj.tagLine = "\((dicInfo.validatedValue(KtagLine, expected: "" as AnyObject).removingPercentEncoding!)!)"
            obj.latitude = "\(dicInfo.validatedValue(KLatitude, expected: "" as AnyObject))"
            obj.longitude = "\(dicInfo.validatedValue(Klong, expected: "" as AnyObject))"
            obj.lastJournalText = "\(dicInfo.validatedValue(KLastJournalText, expected: "" as AnyObject))"
            obj.lastJournalLocation = "\(dicInfo.validatedValue(KLastJournalLocation, expected: "" as AnyObject))"
            obj.state = "\(dicInfo.validatedValue(Kstate, expected: "" as AnyObject))"
            obj.avatarText = "\(dicInfo.validatedValue(kAvatarText, expected: "" as AnyObject))"
            obj.work = "\(dicInfo.validatedValue(Kwork, expected: "" as AnyObject))"
            obj.userId = "\(dicInfo.validatedValue(KuserId, expected: "" as AnyObject))"
            obj.unit = "\(dicInfo.validatedValue(Kunit, expected: "" as AnyObject))"
            let lastJournalDate = "\(dicInfo.validatedValue(KLastJournalDate, expected: "" as AnyObject))"
            if lastJournalDate.length>0 {
                obj.lastJournalDate = getDateFromTimestamp(Double(lastJournalDate)!)
            }
            obj.journalCount = "\(dicInfo.validatedValue(KJournalCount, expected: "" as AnyObject))"
            obj.lastJournalId = "\(dicInfo.validatedValue(KLastJournalId, expected: "" as AnyObject))"
            obj.age = "\(dicInfo.validatedValue(Kage, expected: "" as AnyObject))"
            obj.username = "\(dicInfo.validatedValue(Kusername, expected: "" as AnyObject))"

            obj.profilePicUrl = URL(string: "\(dicInfo.validatedValue(KprofileImage, expected: "" as AnyObject))") as URL!
            obj.avtarImgUrl = URL(string: "\(dicInfo.validatedValue(KavtarImage, expected: "" as AnyObject))") as URL!
            obj.lastJournalPic = URL(string: "\(dicInfo.validatedValue(KLastJournalPic, expected: "" as AnyObject))") as URL!

            obj.journalViewed = (dicInfo.validatedValue(KJournalViewed, expected: false as AnyObject) as! Bool)
            obj.likes = (dicInfo.validatedValue(kLikes, expected: false as AnyObject) as! Bool)
            obj.showWork = (dicInfo.validatedValue(KshowWork, expected: false as AnyObject) as! Bool)
            obj.showSchool = (dicInfo.validatedValue(KshowSchool, expected: false as AnyObject) as! Bool)
            obj.online = (dicInfo.validatedValue(kOnline, expected: false as AnyObject) as! Bool)

            obj.hobbyTags = dicInfo.validatedValue(KHobbyTags, expected: NSArray() as AnyObject) as! [Any]
            obj.personalityTags = dicInfo.validatedValue(KPersonalityTags, expected: NSArray() as AnyObject) as! [Any]
            obj.tags = obj.hobbyTags + obj.personalityTags
            let tagsArray = obj.tags as NSArray
            obj.tagsString = tagsArray.componentsJoined(by: ",")
            
            obj.instagramId = "\(dicInfo.validatedValue(Kinstagram, expected: "" as AnyObject))"
            obj.snapchatId = "\(dicInfo.validatedValue(KsnapchatId, expected: "" as AnyObject))"
            obj.firstName = "\(dicInfo.validatedValue("firstName", expected: "" as AnyObject))"
            
            if obj.city.length>0 &&  obj.state.length>0 && obj.country.length>0{
                obj.address = "\(obj.city), \(obj.state) (\(obj.country))"
            }else if obj.city.length>0 &&  obj.state.length>0{
                obj.address = "\(obj.city), \(obj.state)"
            }
            else if obj.city.length>0 &&  obj.country.length>0{
                obj.address = "\(obj.city) (\(obj.country))"
            }
            else if obj.state.length>0 &&  obj.country.length>0{
                obj.address = "\(obj.state) (\(obj.country))"
            }
            else{
                obj.address = obj.country
            }


            
            userDataArray.add(obj)
        }
        
        return userDataArray
    }

}
