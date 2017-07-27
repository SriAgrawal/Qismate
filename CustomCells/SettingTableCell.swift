//
//  SettingTableCell.swift
//  Qismet
//
//  Created by Lalit on 15/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class SettingTableCell: UITableViewCell {
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var dataBtn: UIButton!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var sepLbl: UILabel!
    @IBOutlet weak var cellButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
