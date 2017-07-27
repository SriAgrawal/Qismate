//
//  TagsTableCell.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TagsTableCell: UITableViewCell {
    
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var tagLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
