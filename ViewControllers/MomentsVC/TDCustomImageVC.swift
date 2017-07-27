//
//  TDCustomImageVC.swift
//  Qismet
//
//  Created by Lalit on 16/03/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import Photos
import DKImagePickerController

class TDCustomImageVC: UIViewController {
    
    let customPicker = DKImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelBtn = UIButton(frame:CGRect(x: (kWindowWidth()-50)/2, y: kWindowHeight()-100, width: 50, height: 50))
        cancelBtn.setImage(UIImage(named: "arrowRight"), for: .normal)
        cancelBtn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cancelBtn.layer.cornerRadius = 25.0
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.borderWidth = 1.5
        cancelBtn.layer.borderColor = UIColor.white.cgColor
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction), for: .touchUpInside)
        customPicker.view.addSubview(cancelBtn)
        
        
        customPicker.singleSelect = true
        customPicker.sourceType = .photo
        view.addSubview(customPicker.view)
        
        let notificationName = Notification.Name("ImageDidSelect")
        NotificationCenter.default.addObserver(self, selector: #selector(imageDidSelect), name: notificationName, object: nil)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelBtnAction(){
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.scrollView.setContentOffset(CGPoint(x: kWindowWidth(), y:0.0), animated: true)
    }
    
    func imageDidSelect(notification: NSNotification){
        let picture = notification.object as! UIImage
        print(picture)
        
        let journalVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCreateJournalVC") as! TDCreateJournalVC
        journalVC.journalImage = picture
        
        //  Add title
        
        if selectedIdea.length > 0 {
            journalVC.customTitle = selectedIdea
        }
        
        let transition = DMAlphaTransition()
        journalVC.transitioningDelegate = transition
        self.present(journalVC, animated: true, completion: nil)
    }
    


}
