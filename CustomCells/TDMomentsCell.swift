//
//  TDMomentsCell.swift
//  Qismet
//
//  Created by Suresh patel on 22/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDMomentsCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.clipsToBounds = true
    }
}
