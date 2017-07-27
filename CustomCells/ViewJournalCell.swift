//
//  ViewJournalCell.swift
//  Qismet
//
//  Created by Lalit on 20/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class ViewJournalCell: UICollectionViewCell {
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var suggestionLbl: UILabel!
    @IBOutlet weak var journalTextLbl: UILabel!
    @IBOutlet weak var suggestionLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalLblHeightConstraint: NSLayoutConstraint!
    
    var tempImageView: UIImageView!
    var motionView: CRMotionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tempImageView = UIImageView()
        
        motionView = CRMotionView.init(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: kWindowHeight()))
        self.contentView.addSubview(motionView)
        self.contentView.sendSubview(toBack: motionView)
        
    }
}
