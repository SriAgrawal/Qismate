//
//  UsernameTableCell.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class UsernameTableCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var usernameTxtfield: UITextField!
    @IBOutlet weak var ageTxtfield: UITextField!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var usernameTxtfieldRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var countLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
