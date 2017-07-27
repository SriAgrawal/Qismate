//
//  TDDiscoverCell.swift
//  Qismet
//
//  Created by Suresh patel on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDDiscoverCell: UITableViewCell {

    @IBOutlet weak var avtarImgView: UIImageView!
    @IBOutlet weak var journalImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var journalBtn: UIButton!
    @IBOutlet weak var journalStampLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var objDiscover = TDDiscoverList()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
