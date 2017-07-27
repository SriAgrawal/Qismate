//
//  TDTagList.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDTagList: NSObject {
    
    var title : String = ""
    var type : String = ""
    var tagId : String = ""
    var isStatus: Bool = false
    
    class func modelFromDict(data : NSMutableArray) -> NSMutableArray {
        
        let dataArray = NSMutableArray()
        for item in data {
            let tagInfo = item as! Dictionary<String, AnyObject>
            let obj = TDTagList()
            obj.isStatus = false
            obj.title = tagInfo["name"] as! String
            dataArray.add(obj)
        }
        return dataArray
    }
    
    
    
    // For Profile Popup
    
    var heading : String = ""
    var data : String = ""


}
