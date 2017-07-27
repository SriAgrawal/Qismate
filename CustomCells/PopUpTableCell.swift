//
//  PopUpTableCell.swift
//  Qismet
//
//  Created by Lalit on 14/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class PopUpTableCell: UITableViewCell {
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var sepLbl: UILabel!
    @IBOutlet weak var dataLblTopConstraint: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
