//
//  SettingSliderCell.swift
//  Qismet
//
//  Created by Lalit on 15/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class SettingSliderCell: UITableViewCell {
    
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var miBtn: UIButton!
    @IBOutlet weak var kmBtn: UIButton!
    @IBOutlet weak var sepLbl: UILabel!
    @IBOutlet weak var slashLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
