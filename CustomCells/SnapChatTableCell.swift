//
//  SnapChatTableCell.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class SnapChatTableCell: UITableViewCell {
    
    @IBOutlet weak var snapchatLbl: UILabel!
    @IBOutlet weak var instagramLbl: UILabel!
    @IBOutlet weak var snapchatTxtField: UITextField!
    @IBOutlet weak var instagramTxtfield: UITextField!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
