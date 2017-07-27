//
//  DiscoverHeaderView.swift
//  Qismet
//
//  Created by Lalit on 06/04/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class DiscoverHeaderView: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    
    class func instanceFromNib() -> DiscoverHeaderView {
        return UINib(nibName: "DiscoverHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DiscoverHeaderView
    }

}
