//
//  TDEditJournalVC.swift
//  Qismet
//
//  Created by Lalit on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

protocol EditJournalDelegate:class {
    func setViewConstraintOnDisappear()
}

class TDEditJournalVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var journalImageView: UIImageView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var saveUpperBtn: UIButton!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var journalTextView: UITextView!
    @IBOutlet weak var textviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate:EditJournalDelegate?
    
    @IBOutlet weak var suggestionTextView: LPlaceholderTextView!
    @IBOutlet weak var suggestionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionTextviewBottomConstraint: NSLayoutConstraint!
    
    var objJournal = TDJournalList()
    var isEditTitle: Bool = false
    var isStartEditing: Bool = false
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDefaults()

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults() {
        
        saveBtn.layer.cornerRadius = 10.5
        saveBtn.clipsToBounds = true
        self.journalTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10)
        self.suggestionTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        print(isEditTitle)
        print(objJournal.journalText)
        
        let tempImgView = UIImageView()
        tempImgView.sd_setImage(with: objJournal.journalImageUrl, completed: { (image, error, type, url) in
            self.journalImageView.image = image
        })
        
        suggestionTextView.delegate = self
        journalTextView.delegate = self
        
        if isEditTitle {
            
            suggestionTextView.text = objJournal.suggestionStr.lowercased()
            suggestionTextViewHeightConstraint.constant = CGFloat(objJournal.suggestionStr.setHeightWithText(strText: objJournal.suggestionStr, width: 20, fontName: kAppFontRegularWithSize(23))+20)
            suggestionTextView.becomeFirstResponder()
            
        }else{
            journalTextView.text = objJournal.journalText
            textViewHeightConstraint.constant = CGFloat(objJournal.journalText.setHeightWithText(strText: objJournal.journalText, width: 20, fontName: kAppFontRegularWithSize(23))+20)
            journalTextView.becomeFirstResponder()
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            textviewBottomConstraint.constant = keyboardHeight
            suggestionTextviewBottomConstraint.constant = keyboardHeight
        }
    }
    
    func showEditActionSheet(){
        
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let editTextButton: UIAlertAction = UIAlertAction(title: "Continue", style: .default)
        { action -> Void in
            
            if self.isEditTitle{
                self.suggestionTextView.becomeFirstResponder()
            }else{
                self.journalTextView.becomeFirstResponder()
            }
        }
        actionSheetController.addAction(editTextButton)
        
        let editTitleButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .default)
        { action -> Void in
            
            if self.isEditTitle{
                self.suggestionTextView.resignFirstResponder()
            }else{
                self.journalTextView.resignFirstResponder()
            }
            self.delegate?.setViewConstraintOnDisappear()
            self.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(editTitleButton)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    //MARK:- UIButton Action
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        if isStartEditing {
            self.showEditActionSheet()
        }else{
            suggestionTextView.resignFirstResponder()
            journalTextView.resignFirstResponder()
            self.delegate?.setViewConstraintOnDisappear()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
//        if isStartEditing {
//            
//            if isEditTitle {
//                objJournal.suggestionStr = suggestionTextView.text.uppercased()
//            }else{
//                objJournal.journalText = journalTextView.text
//            }
//            self.makeWebApiEditJournalWithInfo()
//        }else{
            self.view.endEditing(true)
            self.delegate?.setViewConstraintOnDisappear()
            self.dismiss(animated: true, completion: nil)
      //  }
    }
    
    //MARK:- UITextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView){
        
        backImage.backgroundColor = UIColor.black
        countLbl.isHidden = false
        textView.isHidden = false
        if isEditTitle {
            countLbl.text = "TITLE\n \(objJournal.suggestionStr.length) / 50"
        }else{
            countLbl.text = "CONTEXT\n \(objJournal.suggestionStr.length) / 400"
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        
        if isEditTitle {
            suggestionTextViewHeightConstraint.constant = CGFloat(textView.text.setHeightWithText(strText: textView.text, width: 20, fontName: kAppFontRegularWithSize(23))+20)
        }else{
            
            if CGFloat(textView.text.setHeightWithText(strText: textView.text, width: 20, fontName: kAppFontRegularWithSize(23))+25) <=  kWindowHeight() - textviewBottomConstraint.constant-70 {
                textView.isScrollEnabled = false
                textView.showsVerticalScrollIndicator = false
                textViewHeightConstraint.constant = CGFloat(textView.text.setHeightWithText(strText: textView.text, width: 20, fontName: kAppFontRegularWithSize(23))+25)
            }else{
                textView.isScrollEnabled = true
                textView.showsVerticalScrollIndicator = true
                textViewHeightConstraint.constant = kWindowHeight() - textviewBottomConstraint.constant-70
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        if text == "\n" {
            textView.resignFirstResponder()
            if isStartEditing {
                self.showEditActionSheet()
            }else{
                self.delegate?.setViewConstraintOnDisappear()
                self.dismiss(animated: true, completion: nil)
            }
            return false
        }
        isStartEditing = true
        let newString: String = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if isEditTitle {
            if newString.length < 51 {
                countLbl.text = "TITLE\n \(newString.length) / 50"
                return true
            }else{
                return false
            }

        }else{
            if newString.length < 401 {
                countLbl.text = "CONTEXT\n \(newString.length) / 400"
                return true
            }else{
                return false
            }

        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        
        backImage.backgroundColor = UIColor.clear
        countLbl.isHidden = true
        textView.isHidden = true
        if isEditTitle {
            objJournal.suggestionStr = textView.text.uppercased()
        }else{
            objJournal.journalText = textView.text
        }
    }
    
    //MARK:- Web Service Method For Edit Journal Data
    
    func makeWebApiEditJournalWithInfo(){
        
        let dictParam = NSMutableDictionary();
        
//        var imageData: Data?
//        imageData = UIImageJPEGRepresentation(journalImageView.image!, 0.65)
//        //Checking for image to be less than 1MB before sending it to server
//        
//        if (imageData?.count)! / 1024 / 1024 < 2 {
        
            dictParam[KJournal_Id] = Int(objJournal.journalId)
            dictParam["suggestion"] = objJournal.suggestionStr
            dictParam[Klocation] = objJournal.location
        //    dictParam[Kthumbnil] = imageData
            dictParam[KJournalText] = objJournal.journalText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            if objJournal.albumPhotoDate.length > 0 {
                dictParam[KAlbumPhotoDate] = objJournal.albumPhotoDate
            }
            if objJournal.uploadImageLocation.length > 0 {
                dictParam["image_location"] = objJournal.uploadImageLocation
            }
            
            ServiceHelper.callAPIWithParameters(dictParam, method:.post, apiName: kJournalService) { (result, error) in
                
                
                
            }
       // }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
