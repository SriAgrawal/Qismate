//
//  Validations.swift
//  MobileApp
//
//  Created by Raj Kumar Sharma on 09/10/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

import UIKit

func isValidEmail(_ testStr: String) -> Bool {
    
    let emailRegEx = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
    
}

//func isValidEmail(string:String) -> Bool {
//    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
//    
//    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//    return emailTest.evaluateWithObject(string)
//}

func isValidMobileNumber(_ testStr: String) -> Bool {
    
    let mobileNoRegEx = "^((\\+)|(00)|(\\*)|())[0-9]{9,14}((\\#)|())$"
    let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
    return mobileNoTest.evaluate(with: testStr)
    
}

func isValidName(_ testStr: String) -> Bool {
    
    let nameRegEx = "^[a-zA-Z\\s]+$"
    let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
    return nameTest.evaluate(with: testStr)
    
}

func isValidPassword(_ testStr: String) -> Bool {
    
    let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,12}$"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    return passwordTest.evaluate(with: testStr)
    
}

func phoneNumberFormateWithNumber(_ strPhone:String) -> String
{
    let components = strPhone.components(separatedBy: CharacterSet.decimalDigits.inverted)
    
    let decimalString = components.joined(separator: "") as NSString
    let length = decimalString.length
    let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
    
    var index = 0 as Int
    let formattedString = NSMutableString()
    
    if hasLeadingOne
    {
        formattedString.append("1 ")
        index += 1
    }
    if (length - index) > 3
    {
        let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
        formattedString.appendFormat("(%@)", areaCode)
        index += 3
    }
    if length - index > 3
    {
        let prefix = decimalString.substring(with: NSMakeRange(index, 3))
        formattedString.appendFormat("%@-", prefix)
        index += 3
    }
    
    let remainder = decimalString.substring(from: index)
    formattedString.append(remainder)
    return formattedString as String
}

extension String {
    var isName: Bool {
        let nameRegex = try? NSRegularExpression(pattern: "^[a-zA-Z\\s]+$", options: .caseInsensitive)
        return nameRegex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
}

extension CGRect {
    var wh: (w: CGFloat, h: CGFloat) {
        return (size.width, size.height)
    }
}

func kWindowWidth() -> CGFloat {
    
    let bounds = UIScreen.main.bounds
    let width = bounds.size.width
    return width
    
}

func kWindowHeight() -> CGFloat {
    //
    let bounds = UIScreen.main.bounds
    let height = bounds.size.height
    return height
}


/* resolution of different i-Phones:(w × h)

4-  320 × 480
5-  320 × 568
6-  375 × 667
6+- 414 × 736

*/
