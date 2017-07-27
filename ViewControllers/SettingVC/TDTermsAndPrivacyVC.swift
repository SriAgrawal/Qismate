//
//  TDTermsAndPrivacyVC.swift
//  Qismet
//
//  Created by Lalit on 28/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

class TDTermsAndPrivacyVC: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var termsTextView: UITextView!

    var isFromLogin : Bool = false
    var navigationBarTitle : String!

    
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults() {
        
        self.titleLabel.text = self.navigationBarTitle
        self.closeBtn.isHidden = !self.isFromLogin
        self.backBtn.isHidden = self.isFromLogin
    }
    
    //MARK:- UIButton Actions

    @IBAction func commonBtnAction(_ sender: UIButton) {
        
        if self.isFromLogin {
            self.dismiss(animated: true, completion: nil)
        }
        else{
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }

    
    //MARK:- Memory Warning Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
