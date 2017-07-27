//
//  DummyView.swift
//  DraggableViewController
//
//  Created by Jiri Ostatnicky on 18/05/16.
//  Copyright © 2016 Jiri Ostatnicky. All rights reserved.
//

import UIKit

class BottomBar: UIView {
    
    static let bottomBarHeight: CGFloat = 60
    var button: UIButton!
    var doneLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubview() {
        self.backgroundColor = UIColor.clear
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: 60))
        imageView.image = UIImage(named: "placeholder7")
        imageView.contentMode = .topLeft
        self.addSubview(imageView)

        let shedowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: 60))
        shedowImageView.backgroundColor = UIColor.black
        shedowImageView.alpha = 0.3
        self.addSubview(shedowImageView)

        button = UIButton(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: 60))
       // button.setImage(UIImage(named: "horizontal"), for: .normal)
       // button.setTitle("DONE", for: .normal)
       // button.titleLabel?.font = kAppFontBoldWithSize(13)
        button.backgroundColor = UIColor.clear
        self.addSubview(button)
        
        doneLbl = UILabel(frame: CGRect(x: (kWindowWidth()-60)/2, y: 19, width: 60, height: 21))
        doneLbl.font = kAppFontMediumWithSize(13)
        doneLbl.text = "DONE"
        doneLbl.backgroundColor = UIColor.white
        doneLbl.layer.cornerRadius = 10.5
        doneLbl.clipsToBounds = true
        doneLbl.textAlignment = .center
        self.addSubview(doneLbl)
    }
}
