//
//  UIAlertControllerExtension.swift
//  MobileApp
//
//  Created by Raj Kumar Sharma on 20/10/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

import UIKit

public extension UIAlertController {
    public func kam_show(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        var forefrontVC = rootVC
        while let presentedVC = forefrontVC.presentedViewController {
            forefrontVC = presentedVC
        }
        forefrontVC.present(self, animated: animated, completion: completionHandler)
    }
}
