//
//  TDCountryList.swift
//  Qismet
//
//  Created by Lalit on 28/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDCountryList: NSObject {

    var countryName : String = ""
    var countryCode : String = ""

    class func modelFromDict(_ dic:Dictionary<String, AnyObject>?) -> NSMutableArray {
        
        let userData = dic?.validatedValue("list", expected: NSArray()) as! NSArray
        let userDataArray = NSMutableArray()
        
        for item in userData {
            
            let dicInfo = item as! Dictionary<String, AnyObject>
            let obj = TDCountryList()
            obj.countryName = "\(dicInfo.validatedValue(Kcountry, expected: "" as AnyObject))"
            obj.countryCode = "\(dicInfo.validatedValue(KcountryCode, expected: "" as AnyObject))"
            userDataArray.add(obj)
        }
        
        return userDataArray
    }

}
