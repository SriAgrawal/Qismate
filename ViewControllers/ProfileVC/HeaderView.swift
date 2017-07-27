//
//  HeaderView.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class HeaderView: UIView {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var topProfileImageView: UIImageView!
    @IBOutlet weak var avtarImageView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    class func instanceFromNib() -> HeaderView {
        return UINib(nibName: "HeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HeaderView
    }
    
    
}
