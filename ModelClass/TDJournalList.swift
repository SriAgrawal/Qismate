//
//  TDJournalList.swift
//  Qismet
//
//  Created by Lalit on 20/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDJournalList: NSObject {
    
    var journalId : String = ""
    var journalText : String = ""
    var timestamp : String = ""
    var location : String = ""
    var userName : String = ""
    var albumPhotoDate : String = ""
    var suggestionStr : String = ""
    var uploadImageLocation : String = ""
    var secondLocation : String = ""
    var journalImageUrl : URL?
    var avtarImgUrl : URL?
    
    class func modelFromDict(_ infoDict:Dictionary<String, AnyObject>?) -> TDJournalList {
        
        let obj = TDJournalList()
        
        obj.userName = "\((infoDict?.validatedValue(Kusername, expected: "" as AnyObject))!)"
        obj.avtarImgUrl = URL(string: "\((infoDict?.validatedValue(KavtarImage, expected: "" as AnyObject))!)") as URL!
        
        obj.journalId = "\((infoDict?.validatedValue(Kid, expected: "" as AnyObject))!)"
        obj.journalText = "\((infoDict?.validatedValue(KJournalText, expected: "" as AnyObject).removingPercentEncoding!)!)"
        obj.journalImageUrl = URL(string: "\((infoDict?.validatedValue("imageFile", expected: "" as AnyObject))!)") as URL!
        obj.suggestionStr = "\((infoDict?.validatedValue("suggestion", expected: "" as AnyObject))!)"
        obj.location = "\((infoDict?.validatedValue(Klocation, expected: "" as AnyObject))!)"
        obj.timestamp = "\((infoDict?.validatedValue(KTimeElapsed, expected: "" as AnyObject))!)"
        obj.timestamp = getDateFromTimestamp(Double(obj.timestamp)!)
        obj.albumPhotoDate = "\((infoDict?.validatedValue(KAlbumPhotoDate, expected: "" as AnyObject))!)"
        if obj.albumPhotoDate.length > 0 {
            obj.albumPhotoDate = obj.getTakenDate(fromTimestamp: Double(obj.albumPhotoDate)!)
        }
        obj.uploadImageLocation = "\((infoDict?.validatedValue("imageLocation", expected: "" as AnyObject))!)"
        
        return obj
        
    }
    
    func getTakenDate(fromTimestamp timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        let dateString: String = dateFormatter.string(from: date)
        return dateString
    }
}
