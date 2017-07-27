//
//  TDUserPreferences.swift
//  Qismet
//
//  Created by Lalit on 15/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDUserPreferences: NSObject {
    
    var strLowerAge : String = ""
    var strUpperAge : String = ""
    var strRadius : String = ""
    var strRadiusUnit : String = ""
    var strSearch : String = ""
    var sex : String = "0"
    var country : String = ""
    var historySearch : String = ""
    var strDiscoveryOption : String = ""
    var strPickerOption : String = ""
    var strNearByOption : String = ""
    
    var isSound: Bool = false
    var isProfileHidden: Bool = false
    var isCompliments: Bool = false
    var isExpand: Bool = false
    var isFirst: Bool = false
    var isSavePhoto: Bool = false
    var isPrivateJournal: Bool = false
    
    
    class func modelFromDict(_ dic:Dictionary<String, AnyObject>?) -> TDUserPreferences {
        
        let obj = TDUserPreferences()
        
        if let dicInfo = dic {
            
            obj.isProfileHidden = (dicInfo.validatedValue(KhideProfile, expected: false as AnyObject) as! Bool)
            obj.isSound = (dicInfo.validatedValue(Knotification, expected: false as AnyObject) as! Bool)
            obj.strRadius = "\(dicInfo.validatedValue(Kradius, expected: "" as AnyObject))"
            obj.strRadiusUnit = "\(dicInfo.validatedValue(KRadiusUnit, expected: "" as AnyObject))"
            obj.strSearch = "\(dicInfo.validatedValue(Ksearch, expected: "" as AnyObject))"
            obj.country = "\(dicInfo.validatedValue(Kcountry, expected: "" as AnyObject))"
            obj.sex = "\(dicInfo.validatedValue(Kgender, expected: "0" as AnyObject))"
            obj.strUpperAge = "\(dicInfo.validatedValue(Kupper_age, expected: "" as AnyObject))"
            obj.strLowerAge = "\(dicInfo.validatedValue(Klower_age, expected: "" as AnyObject))"
            obj.historySearch = "\(dicInfo.validatedValue(KHistorySearch, expected: "" as AnyObject))"
            obj.isCompliments = (dicInfo.validatedValue(KCompliments, expected: false as AnyObject) as! Bool)
            obj.isSavePhoto = (dicInfo.validatedValue(KsavePhoto, expected: false as AnyObject) as! Bool)
            obj.isPrivateJournal = (dicInfo.validatedValue(KprivateJournal, expected: false as AnyObject) as! Bool)

        }
                
        return obj
    }
    
}
