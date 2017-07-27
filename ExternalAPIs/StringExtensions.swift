//
//  StringExtensions.swift
//  MobileApp
//
//  Created by Raj Kumar Sharma on 04/04/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func contains(_ string: String) -> Bool {
        return self.range(of: string) != nil
    }
    
    func substringFromIndex(_ index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: index))
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func setHeightWithText(strText: String, width: CGFloat, fontName: UIFont) -> Int {
        let dateStringSize: CGRect = strText.boundingRect(with: CGSize(width: CGFloat(kWindowWidth() - width), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: fontName], context: nil)
        return Int(dateStringSize.size.height)
    }
    
    func substringToIndex(_ index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: index))
    }
    func getSubstringWithRange(_ start: Int, end: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            //print("start index \(start) out of bounds")
            return ""
        } else if end < 0 || end > self.characters.count {
            //print("end index \(end) out of bounds")
            return ""
        }
        
        let range = (self.characters.index(self.startIndex, offsetBy: start) ..< self.characters.index(self.startIndex, offsetBy: end))
        return self.substring(with: range)
    }
    
    func substringWithRange(_ start: Int, location: Int) -> String {
        if (start < 0 || start > self.characters.count) {
            //print("start index \(start) out of bounds")
            return ""
        } else if location < 0 || start + location > self.characters.count {
            //print("end index \(start + location) out of bounds")
            return ""
        }
        let range = (self.characters.index(self.startIndex, offsetBy: start) ..< self.characters.index(self.startIndex, offsetBy: start + location))
        return self.substring(with: range)
    }
    
    func trimWhiteSpace () -> String {
        
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmedString
    }
    
    func isValidMobileNumber() -> Bool {
        
        let mobileNoRegEx = "^((\\+)|(00)|(\\*)|())[0-9]{9,14}((\\#)|())$"
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        return mobileNoTest.evaluate(with: self)
    }
    
    var isEmail: Bool {
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func dateFromString(_ format:String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Unable to format date")
        }
        
        return nil
    }
    
    func date() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Unable to format date")
        }
        
        return nil
    }
    
    //>>>> removes all whitespace from a string, not just trailing whitespace <<<//
    
    func removeWhitespace() -> String {
        return self.replaceString(" ", withString: "")
    }
    
    //>>>> Replacing String with String <<<//
    func replaceString(_ string:String, withString:String) -> String {
        return self.replacingOccurrences(of: string, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
//    func numberOfLinesForString(_ size: CGSize, font: UIFont) -> Int {
//        let textStorage = NSTextStorage(string: self, attributes: [NSFontAttributeName: font])
//        
//        let textContainer = NSTextContainer(size: size)
//        textContainer.lineBreakMode = .byWordWrapping
//        textContainer.maximumNumberOfLines = 0
//        textContainer.lineFragmentPadding = 0
//        
//        let layoutManager = NSLayoutManager()
//        layoutManager.textStorage = textStorage
//        layoutManager.addTextContainer(textContainer)
//        
//        var numberOfLines = 0
//        var index = 0
//        var lineRange : NSRange = NSMakeRange(0, 0)
//        
//        for (; index < layoutManager.numberOfGlyphs; numberOfLines += 1) {
//            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
//            index = NSMaxRange(lineRange)
//        }
//        
//        return numberOfLines
//    }
    
    func getAttributedString(_ string_to_Attribute:String, color:UIColor, font:UIFont) -> NSAttributedString {
        
        let range = (self as NSString).range(of: string_to_Attribute)
        
        let attributedString = NSMutableAttributedString(string:self)
        
        // multiple attributes declared at once
        let multipleAttributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: font,
            ]
        
        attributedString.addAttributes(multipleAttributes, range: range)
        
        return attributedString.mutableCopy() as! NSAttributedString
    }
    
    //    func recursiveAttributedString(string_to_Attribute:String, color:UIColor, font:UIFont) -> NSAttributedString {
    //
    //        let effectedStr1 = "(\(string_to_Attribute))"
    //
    //        var attributedString = NSMutableAttributedString(string:self)
    //
    //        let regex = NSRegularExpression(pattern: effectedStr1, options: [], error: nil)
    //
    //        let range = NSMakeRange(0, self.length)
    //
    //        let stringOneMatches = regex.matchesInString(self, options: [.CaseInsensitive], range: range)
    //
    //        for stringOneMatch in stringOneMatches {
    //            let wordRange = stringOneMatch.rangeAtIndex(0)
    //            attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: wordRange)
    //            attributedString.addAttribute(NSFontAttributeName, value: font, range: wordRange)
    //        }
    //
    //        return attributedString.mutableCopy() as! NSAttributedString
    //    }
    
    //>>>>>>>>>>>>>>>>>>>>>> Finding OccurrencesOfString <<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
//    func occurrencesOfString(_ aString: String) -> Int {
//        var occurrences: Int = 0
//        // Set the initial range to the full string
//        var range: Range<String.Index>? = self.characters.indices
//        
//        while range != nil {
//            // Search for the string in the current range
//            range = self.range(of: aString,
//                                       options: NSString.CompareOptions.caseInsensitive,
//                                       range: range,
//                                       locale: nil)
//            
//            if range != nil {
//                // String was found, move the range
//                range = range!.upperBound..<self.endIndex
//                // Increment the number of occurrences
//                occurrences += 1
//            }
//        }
//        return occurrences
//    }
    
    // Returns a range of characters (e.g. s[0...3])
    subscript (r: Range<Int>) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.characters.index(self.startIndex, offsetBy: r.upperBound)
        return substring(with: (start ..< end))
    }
    
    // Returns the nth character (e.g. s[1])
//    subscript (i: Int) -> String {
//        
//        return self[i...i]
//    }
}

