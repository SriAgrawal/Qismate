//
//  AboutTextTableCell.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class AboutTextTableCell: UITableViewCell {
    
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var aboutTextView: LPlaceholderTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
