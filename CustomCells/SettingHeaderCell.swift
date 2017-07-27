//
//  SettingHeaderCell.swift
//  Qismet
//
//  Created by Lalit on 15/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class SettingHeaderCell: UITableViewCell {
    
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var sepLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
