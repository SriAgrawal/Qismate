//
//  FNPAppUtility.swift
//  FNP
//
//  Created by Suresh patel on 22/11/16.
//  Copyright © 2016 Cochify. All rights reserved.
//

import UIKit

let showLog = true

func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}


func getDateFromTimestamp(_ timestamp: Double) -> String {
    
    let current = Date()
    let objDateFormatter = DateFormatter()
    objDateFormatter.dateFormat = "YYYY"
    let currentYear: String = objDateFormatter.string(from: current)
    let date = Date(timeIntervalSince1970: timestamp / 1000)
    let dateFormatter = DateFormatter()
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "YYYY"
    let year: String = dateFormatter1.string(from: date)
    dateFormatter.dateFormat = "MMM d"
    var dateString1: String = dateFormatter.string(from: date)
    dateString1 = "\(dateString1)"
    
    let distanceBetweenDates: TimeInterval = current.timeIntervalSince(date)
    let min: Int = Int(distanceBetweenDates) / 60
    let gregorianCalendar = Calendar(identifier: .gregorian)
    //        var components: DateComponents? = gregorianCalendar.dateComponents(.day, from: date, to: current, options:.wrapComponents)
    var components: DateComponents? = (gregorianCalendar as NSCalendar).components(.day, from: date)
    
    let noOfDay: Int? = components?.day
    
    if min <= 59 {
        if min < 1 {
            return "Just Now"
        }
        else if min == 1 {
            return "\(min) ago"
        }
        else {
            return "\(min) ago"
        }
    }
    else if (min / 60) <= 23 {
        if (min / 60) == 1 {
            return "\(min / 60) ago"
        }
        else {
            return "\(min / 60) ago"
        }
    }
    else if noOfDay! < 4 {
        if noOfDay! <= 1 {
            return "\(noOfDay) ago"
        }
        else {
            return "\(noOfDay) ago"
        }
    }
    else {
        if (year == currentYear) {
            return "\(dateString1)"
        }
        else {
            //             return [NSString stringWithFormat:@"%@, %@",_dateString,year];
            return "\(year)"
        }
    }
}


// custom log
func logInfo(_ message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    if (showLog) {
        print("\(function): \(line): \(message)")
        //Log.writeLog(message: message, clazz: file, function: function, line: line, column: column)
    }
}

var CurrentTimestamp: String {
    return "\(Date().timeIntervalSince1970)"
}

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

let filterNameList = ["No Filter", "CIPhotoEffectNoir", "CIPhotoEffectChrome", "CIPhotoEffectProcess", "CIColorPosterize", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]

let filterDisplayNameList = ["Original", "Noir", "Chrome", "Process", "Poster", "Instant", "Mono", "Tonal", "Transfer"]

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get AppFont with Size <<<<<<<<<<<<<<<<<<<<<<<<*/
func kAppFontRegularWithSize(_ size:CGFloat) -> UIFont {  return UIFont(name:"AvenirNext-Regular", size: size)!
}
func kAppFontBoldWithSize(_ size:CGFloat) -> UIFont {
    return UIFont(name:"AvenirNext-Bold", size: size)!
}
func kAppFontMediumWithSize(_ size:CGFloat) -> UIFont {
    return UIFont(name:"AvenirNext-Medium", size: size)!
}
func kAppFontMediumBoldItalicWithSize(_ size:CGFloat) -> UIFont {
    return UIFont(name:"Lato-BlackItalic", size: size)!
}
func kAppFontLightWithSize(_ size:CGFloat) -> UIFont {
    return UIFont(name:"AvenirNext-Light", size: size)!
}
func kAppFontItalicWithSize(_ size:CGFloat) -> UIFont {
    return UIFont(name:"AvenirNext-Italic", size: size)!
}
func kAppFontLightItalicWithSize(_ size:CGFloat) -> UIFont {
    return UIFont(name:"AvenirNext-Light", size: size)!
}
func kAppFontDemiBoldWithSize(_ size:CGFloat) -> UIFont {
    return UIFont(name:"AvenirNext-DemiBold", size: size)!
}
func RGBA(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func getImageFromColor(_ color:UIColor) -> UIImage {
    
    let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size);
    let context: CGContext = UIGraphicsGetCurrentContext()!
    context.setFillColor(color.cgColor);
    context.fill(rect);
    let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext();
    
    return img;
}

func getRatingDescriptionForRating(_ rating:Float) ->NSString {
    // return blank on zero
    if (rating == 1) {
        return "Yuck: Vomited in my mouth a little"
    } else if (rating <= 1.5) {
        return "Awful: Instant regret"
    } else if (rating <= 2) {
        return "Bad: Barely edible"
    } else if (rating <= 2.5) {
        return "Meh: I could make better"
    } else if (rating <= 3) {
        return "Average: Nothing special"
    } else if (rating <= 3.5) {
        return "Good: I would recommend this"
    } else if (rating <= 4) {
        return "Very Good: Drool worthy"
    } else if (rating <= 4.5) {
        return "Outstanding: I'd come here just for this dish"
    } else if (rating <= 5) {
        return "Perfection: What dreams are made of"
    } else {
        return ""
    }
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get WeekDay for date <<<<<<<<<<<<<<<<<<<<<<<<*/
//EEEE for weekday, //"dd/MM/yy", //"yyyy-MM-dd"
//"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ" -->UTC date formate

func getStringFromDate(_ date:Date, format:NSString) -> NSString {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format as String
    
    return dateFormatter.string(from: date) as NSString
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get UnderLined Attributed String <<<<<<<<<<<<<<<<<<<<<<<<*/
func getUnderLinedAttributedString(_ str:NSString) -> NSAttributedString {
    
    let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
    let underlineAttributedString = NSAttributedString(string: str as String, attributes: underlineAttribute)
    
    return underlineAttributedString
}
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Attributed String <<<<<<<<<<<<<<<<<<<<<<<<*/
func getAttributedString(_ fullStr:NSString, attributableStr:NSString, color:UIColor, font:UIFont) -> NSAttributedString {
    //let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
    //let underlineAttributedString = NSAttributedString(string: fullStr as String, attributes: underlineAttribute)
    
    //let effectedStr1:NSString = "(\(attributableStr))"//"("+attributableStr+")"
    //let mutableAttributedString = NSMutableAttributedString(string: fullStr as String)
    
    //let regex = NSRegularExpression.re
    
    //myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location:10,length:5))
    
    //return underlineAttributedString
    
    let attributes = [
        NSFontAttributeName : UIFont(name: "Helvetica Neue", size: 12.0)!,
        NSUnderlineStyleAttributeName : 1,
        NSForegroundColorAttributeName : UIColor.red,
        NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
        NSStrokeWidthAttributeName : 3.0
        ] as [String : Any]
    
    let atriString = NSAttributedString(string: "My Attributed String", attributes: attributes)
    
    return atriString
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UIButton <<<<<<<<<<<<<<<<<<<<<<<<*/
func setCornerForButton(_ button:UIButton, cornerRadius:CGFloat, borderWidth:CGFloat, borderColor:UIColor) {
    button.layer.cornerRadius =  cornerRadius
    button.layer.borderColor = borderColor.cgColor
    button.layer.borderWidth = borderWidth
    button.clipsToBounds = true
}

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Setting corner for UIButton <<<<<<<<<<<<<<<<<<<<<<<<*/
func setCornerForImageView(_ imageView:UIImageView, cornerRadius:CGFloat, borderWidth:CGFloat, borderColor:UIColor) {
    imageView.layer.cornerRadius =  cornerRadius
    imageView.layer.borderColor = borderColor.cgColor
    imageView.layer.borderWidth = borderWidth
    imageView.clipsToBounds = true
}

// convert images into base64 and keep them into string
func convertImageToBase64(_ image: UIImage, compressionQuality:CGFloat) -> String {
    
    let imageData = UIImageJPEGRepresentation(image, compressionQuality)
    let base64String = imageData!.base64EncodedString(options: [])
    
    return base64String
    
}// end convertImageToBase64

func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json
        } catch {
            //print("Something went wrong    \(text)")
        }
    }
    return nil
}

func trimWhiteSpace (_ str: String) -> String {
    let trimmedString = str.trimmingCharacters(in: CharacterSet.whitespaces)
    return trimmedString
}

func giveLeftPaddingToTextField(_ textField: UITextField, width: Int , height: Int) {
    
    let leftPaddingView = UIView(frame: CGRect(x: 0,y: 0, width: width, height: height))
    textField.leftView = leftPaddingView
    textField.leftViewMode = .always
}

func jwtTokenInfo(_ tokenStr:String) -> Dictionary<String, AnyObject>? {
    
    let segments = tokenStr.components(separatedBy: ".")
    
    var base64String = segments[1] as String
    
    if base64String.characters.count % 4 != 0 {
        let padlen = 4 - base64String.characters.count % 4
        base64String += String(repeating: "=", count: padlen)
    }
    
    if let data = Data(base64Encoded: base64String, options: []) {
        do {
            let tokenInfo = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return tokenInfo as? Dictionary<String, AnyObject>
        } catch {
            logInfo("error to generate jwtTokenInfo >>>>>>  \(error)")
        }
    }
    return nil
}
func storyboardForName(name:String) -> UIStoryboard{
    return UIStoryboard(name: name, bundle: nil)
}


class FNPAppUtility: NSObject {

}
