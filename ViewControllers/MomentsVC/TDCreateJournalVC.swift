//
//  TDCreateJournalVC.swift
//  Qismet
//
//  Created by Suresh patel on 23/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit


enum ScreenModeType {
    case editing,filter,drawing,nothing
}


class TDCreateJournalVC: UIViewController,UITextViewDelegate, YSLContainerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,StickerSelectDelegate, UIGestureRecognizerDelegate,SNSliderDataSource,StickerDelegate {
    
    
    @IBOutlet weak var filterSwitcherView: UIView!
    @IBOutlet weak var blurImageView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var stickerBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var drawingBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var suggestionLbl: UILabel!
    @IBOutlet weak var journalLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var suggestionLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionTextView: LPlaceholderTextView!
    @IBOutlet weak var suggestionTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestionTextviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextView: LPlaceholderTextView!
    @IBOutlet weak var journalTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var journalTextViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    // Drawing Working Outlet
    
    @IBOutlet weak var mainDrawingView: UIView!
    @IBOutlet weak var drawingBackBtn: UIButton!
    @IBOutlet weak var drawingBtnOnView: UIButton!
    @IBOutlet weak var drawingUndoBtn: UIButton!
    @IBOutlet weak var bubbleView: UIImageView!
    @IBOutlet weak var paintView: PaintView!
    
    // SnapSliderFilter
    
    var slider:SNSlider = SNSlider(frame: CGRect(origin: CGPoint.zero, size: SNUtils.screenSize))
    var data:[SNFilter] = []
    
    var journalImage: UIImage!
    var journalImageCopy: UIImage!
    var customTitle: String = ""
    var fixTitle: String = ""
    var isSplitJournal: Bool = false
    var motionView: CRMotionView!
    var keyBoardHeight: CGFloat!
    var isEditTitle: Bool = false
    var ScreenMode = ScreenModeType.nothing
    var popUp : STPopupController!
    var selectedFilterName = "Original"
    var stickerDic: Dictionary<String, Any>!
    var stickerViewDic = NSMutableDictionary()
    var stickerImageDic = NSMutableDictionary()
    var stiCount: Int = 511
    var lastRotation: CGFloat = 0.0
    
    var customNotification = CWStatusBarNotification()
    
    fileprivate let context = CIContext(options: nil)
    
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDefaults()
        self.callWebApiForGetStickers()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.setAnimationsEnabled(true)
        
    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults(){
        
        //        motionView = CRMotionView.init(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: kWindowHeight()))
        //        motionView.image = journalImage
        //        motionView.isMotionEnabled = true
        //        motionView.contentMode = .scaleAspectFill
        //        self.view.addSubview(motionView)
        //        self.view.sendSubview(toBack: motionView)
        //        self.view.sendSubview(toBack: filterSwitcherView)
        
        // SnapSliderFilter
        
        self.createData(journalImage)
        self.slider.dataSource = self
        self.slider.isUserInteractionEnabled = true
        self.slider.isMultipleTouchEnabled = true
        self.slider.isExclusiveTouch = false
        self.filterSwitcherView.addSubview(slider)
        self.slider.reloadData()
        
        
        journalImageCopy = journalImage
        
        saveBtn.isExclusiveTouch = true
        backBtn.isExclusiveTouch = true
        stickerBtn.isExclusiveTouch = true
        filterBtn.isExclusiveTouch = true
        drawingBtn.isExclusiveTouch = true
        
        //        UITextView.appearance().tintColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        self.journalTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10)
        self.suggestionTextView.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10)
        suggestionTextView.delegate = self
        journalTextView.delegate = self
        
        if customTitle.length > 0{
//            suggestionLbl.text = customTitle
//            suggestionTextView.text = customTitle
//            suggestionTextViewHeightConstraint.constant = CGFloat(suggestionTextView.text.setHeightWithText(strText: suggestionTextView.text, width: 20, fontName: kAppFontRegularWithSize(23))+20)
            journalLbl.text = customTitle
            journalTextView.text = customTitle
            journalTextViewHeightConstraint.constant = CGFloat(journalTextView.text.setHeightWithText(strText: journalTextView.text, width: 20, fontName: kAppFontRegularWithSize(23))+25)
            journalLblHeightConstraint.constant = CGFloat(((journalLbl.text?.setHeightWithText(strText: journalLbl.text!, width: 28, fontName: kAppFontItalicWithSize(22)))!+10))
        }
        else{
          //  suggestionLbl.text = "TAP HERE TO TITLE THIS MOMENT."
            journalLbl.text = "Type something here."
            journalLblHeightConstraint.constant = 25
        }
        
//        let tapOnSuggestion = UITapGestureRecognizer(target: self, action:#selector(tapOnSuggestionAction))
//        suggestionLbl.addGestureRecognizer(tapOnSuggestion)
        
        let tapOnJournal = UITapGestureRecognizer(target: self, action:#selector(tapOnJournalAction))
        journalLbl.addGestureRecognizer(tapOnJournal)
        
        let tapOnblur = UITapGestureRecognizer(target: self, action:#selector(tapOnblurAction))
        blurImageView.addGestureRecognizer(tapOnblur)
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        
        //  if isSplitJournal {
        filterBtn.isHidden = true
        //  }
        
        // Custom Notification
        
        customNotification.notificationAnimationInStyle = CWNotificationAnimationStyle(rawValue: 0)!
        customNotification.notificationAnimationOutStyle = CWNotificationAnimationStyle(rawValue: 0)!
        customNotification.notificationStyle = .navigationBarNotification
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyBoardHeight = keyboardSize.height
            journalTextViewBottomConstraint.constant = keyBoardHeight
            suggestionTextviewBottomConstraint.constant = keyBoardHeight
        }
    }
    
    func isHiddenButtonsOnEditing(_ status: Bool) {
        
        saveBtn.isHidden = status
        drawingBtn.isHidden = status
        stickerBtn.isHidden = status
        downloadBtn.isHidden = status
//        if !isSplitJournal {
//            filterBtn.isHidden = status
//        }
      //  suggestionLbl.isHidden = status
        journalLbl.isHidden = status
    }
    
    // SnapSliderFilter Function
    
    func createData(_ image: UIImage) {
        
        self.data = SNFilter.generateFilters(SNFilter(frame: self.slider.frame, withImage: image), filters: SNFilter.filterNameList)
        
        self.data[7].addSticker(SNSticker(frame: CGRect(x: 0, y: 0, width:kWindowWidth(),height: kWindowHeight()), image: UIImage(named: "snappyInk")!))
        self.data[8].addSticker(SNSticker(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: kWindowHeight()), image: UIImage(named: "sanfran")!))
        self.data[9].addSticker(SNSticker(frame: CGRect(x: 0, y: 0, width: kWindowWidth(), height: kWindowHeight()), image: UIImage(named: "losangeles")!))
    }
    
    //MARK:- SnapSliderFilter DataSource Methods
    
    func numberOfSlides(_ slider: SNSlider) -> Int {
        return data.count
    }
    
    func slider(_ slider: SNSlider, slideAtIndex index: Int) -> SNFilter {
        
        return data[index]
    }
    
    func startAtIndex(_ slider: SNSlider) -> Int {
        return 0
    }


    //MARK:- UITapGesture Actions
    
    func tapOnSuggestionAction(){
        
        isEditTitle = true
        suggestionTextView.becomeFirstResponder()
    }
    
    func tapOnJournalAction(){
        
        isEditTitle = false
        journalTextView.becomeFirstResponder()
    }
    
    func tapOnblurAction(){
        
        switch ScreenMode {
            
        case .editing:
            self.view.endEditing(true)
            break
            
        case .filter:
            self.filterBtnAction(filterBtn)
            break
            
        default: break
            
        }
    }
    
    //MARK:- UIButton Actions
    
    @IBAction func downloadBtnAction(_ sender: UIButton) {
        
        FlareView.sharedCenter().flarify(downloadBtn, inParentView: self.view, with: RGBA(255, g: 255, b: 255, a: 1.0))
        self.perform(#selector(callDownload), with: nil, afterDelay: 1.8)
    }
    
    func callDownload(){
        
        let myView: UIView? = Bundle.main.loadNibNamed("CustomView", owner: nil, options: nil)?[0] as? UIView
        customNotification.display(with: myView, forDuration: 1.0)
        let picture = SNUtils.screenShot(filterSwitcherView)
        print(picture!)
        UIImageWriteToSavedPhotosAlbum(self.normalizedImage(from: picture!), nil, nil, nil)

    }
    
    func normalizedImage(from image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let normalizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage!
    }

    
    @IBAction func backBtnAction(_ sender: UIButton) {
        
        switch ScreenMode {
            
        case .nothing:
            
            
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelActionButton)
            
            let discardActionButton: UIAlertAction = UIAlertAction(title: "Discard Changes", style: .default)
            { action -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            actionSheetController.addAction(discardActionButton)
            
            self.present(actionSheetController, animated: true, completion: nil)
            
            break
            
        case .editing:
            self.view.endEditing(true)
            break
            
        case .drawing:
            break
            
        case .filter:
            self.filterBtnAction(filterBtn)
            break
                        
        }
    }
    
    func dismissModalStack() {
        var vc: UIViewController? = self.presentingViewController
        while ((vc?.presentingViewController) != nil) {
            if !(vc is TDHomeVC) {
                vc = vc?.presentingViewController
            }else{
                break
            }
        }
        vc?.dismiss(animated: true, completion: { _ in })
    }
    
  /*  @IBAction func stickerBtnAction(_ sender: Any) {
        
//        let stickerVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
//        stickerVC.title = "STICKERS"
//        stickerVC.delegate = self
//        stickerVC.screenType = .sticker
        
        let stickerVC1 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
        stickerVC1.title = "STYLE"
        stickerVC1.screenType = .style
        
        let stickerVC2 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
        stickerVC2.title = "FLOWERS"
        let dic = stickerDic.validatedValue("flowers", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
        stickerVC2.customDataArray = dic.validatedValue("index", expected: NSArray() as AnyObject) as! [Any]
        stickerVC2.screenType = .flowers
        stickerVC2.delegate = self
        
        let stickerVC3 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
        stickerVC3.title = "FOODIE"
        let fDic = stickerDic.validatedValue("foodies", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
        stickerVC3.customDataArray = fDic.validatedValue("white", expected: NSArray() as AnyObject) as! [Any]
        stickerVC3.screenType = .flowers
        stickerVC3.delegate = self
        
//        let stickerVC4 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
//        stickerVC4.title = "MONSTER"
//        let mDic = stickerDic.validatedValue("monsters", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
//        stickerVC4.customDataArray = mDic.validatedValue("pack1", expected: NSArray() as AnyObject) as! [Any]
//        stickerVC4.screenType = .monster
//        stickerVC4.delegate = self
        
        let stickerVC5 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
        stickerVC5.title = "EMOJI"
        let twDic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
        stickerVC5.customDataArray = twDic.validatedValue("activity", expected: NSArray() as AnyObject) as! [Any]
        stickerVC5.screenType = .twemoji
        stickerVC5.delegate = self
        
        let stickerVC6 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
        stickerVC6.title = "QUOTES"
        stickerVC6.delegate = self
        stickerVC6.screenType = .quotes
        let qDic = stickerDic.validatedValue("script-quotes", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
        let stiArray: NSMutableArray = qDic.validatedValue("white", expected: NSMutableArray() as AnyObject) as! NSMutableArray
        for i in 0..<stiArray.count {
            let str: NSString = stiArray[i] as! NSString
            if str.contains("quotes-7") {
                stiArray.removeObject(at: i)
                break
            }
        }
        let sd = NSSortDescriptor(key: nil, ascending: true)
        stickerVC6.customDataArray = (stiArray as NSArray).sortedArray(using: [sd])
        let blackArray: NSArray = qDic.validatedValue("black", expected: NSArray() as AnyObject) as! NSArray
        stickerVC6.customBlackArray = blackArray.sortedArray(using: [sd])
        
//        let stickerVC7 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDStickerVC") as! TDStickerVC
//        stickerVC7.title = "IDEAS"
//        stickerVC7.delegate = self
//        stickerVC7.screenType = .ideas
//        let sDic = stickerDic.validatedValue("suggestion", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
//        stickerVC7.customDataArray = sDic.validatedValue("white", expected: NSArray() as AnyObject) as! [Any]
//        stickerVC7.customBlackArray = sDic.validatedValue("black", expected: NSArray() as AnyObject) as! [Any]

        
        let containerVC = YSLContainerViewController(controllers:[stickerVC5,stickerVC2,stickerVC6,stickerVC3], topBarHeight: 30, parentViewController: self) as YSLContainerViewController
        
//        let containerVC = YSLContainerViewController(controllers:[stickerVC,stickerVC1], topBarHeight: 40, parentViewController: self) as YSLContainerViewController

        containerVC.setContentSize()
        containerVC.menuItemTitleColor = UIColor.init(white: 1.0, alpha: 0.3)
        containerVC.menuItemSelectedTitleColor = UIColor.white
        containerVC.menuIndicatorColor = UIColor.white
        containerVC.view.backgroundColor = UIColor.clear
        containerVC.menuItemFont = kAppFontBoldWithSize(13)
        containerVC.delegate = self
        
        popUp = STPopupController(rootViewController: containerVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.navigationBarHidden = true
        popUp.style = STPopupStyle.bottomSheet
        popUp.transitionStyle = STPopupTransitionStyle.fade
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = popUp.containerView.bounds
        blurView.autoresizingMask = .flexibleWidth
        popUp.containerView.addSubview(blurView)
        popUp.containerView.sendSubview(toBack: blurView)
        
        let image = UIImage(named: "arrowWhite")
        let backBtn : UIButton!
        backBtn = UIButton()
        backBtn.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        backBtn.setImage(image, for: .normal)
        backBtn.addTarget(self, action: #selector(stickerBackAction), for: .touchUpInside)
        popUp.containerView.addSubview(backBtn)
        
        let image1 = UIImage(named: "stickerIcon")
        let tagBtn : UIButton!
        tagBtn = UIButton()
        tagBtn.frame = CGRect(x: (kWindowWidth()-40)/2, y: 5, width: 40, height: 40)
        tagBtn.setImage(image1, for: .normal)
        tagBtn.addTarget(self, action: #selector(stickerBackAction), for: .touchUpInside)
        popUp.containerView.addSubview(tagBtn)
        
        popUp.present(in: self)
    } */
    
    @IBAction func stickerBtnAction(_ sender: Any) {
        
        let emojiDic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
        
        let stickerVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC.stickerArray = emojiDic.validatedValue("people", expected: NSArray() as AnyObject) as! [Any]
        stickerVC.screenType = .Smileys
        stickerVC.delegate = self
        
        let stickerVC1 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC1.stickerArray = emojiDic.validatedValue("nature", expected: NSArray() as AnyObject) as! [Any]
        stickerVC1.screenType = .Animal
        stickerVC1.delegate = self
        
        let stickerVC2 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC2.stickerArray = emojiDic.validatedValue("food", expected: NSArray() as AnyObject) as! [Any]
        stickerVC2.screenType = .Food
        stickerVC2.delegate = self
        
        let stickerVC3 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC3.stickerArray = emojiDic.validatedValue("activity", expected: NSArray() as AnyObject) as! [Any]
        stickerVC3.screenType = .Activity
        stickerVC3.delegate = self
        
        let stickerVC4 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC4.stickerArray = emojiDic.validatedValue("travel", expected: NSArray() as AnyObject) as! [Any]
        stickerVC4.screenType = .Travel
        stickerVC4.delegate = self
        
        let stickerVC5 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC5.stickerArray = emojiDic.validatedValue("objects", expected: NSArray() as AnyObject) as! [Any]
        stickerVC5.screenType = .Object
        stickerVC5.delegate = self
        
        let stickerVC6 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC6.stickerArray = emojiDic.validatedValue("symbols", expected: NSArray() as AnyObject) as! [Any]
        stickerVC6.screenType = .Symbol
        stickerVC6.delegate = self
        
        let stickerVC7 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        stickerVC7.stickerArray = emojiDic.validatedValue("flags", expected: NSArray() as AnyObject) as! [Any]
        stickerVC7.screenType = .Flag
        stickerVC7.delegate = self
        
        let stickerVC8 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        let dic = stickerDic.validatedValue("flowers", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
        stickerVC8.stickerArray = dic.validatedValue("index", expected: NSArray() as AnyObject) as! [Any]
        stickerVC8.screenType = .Flower
        stickerVC8.delegate = self
        
        let stickerVC9 = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCustomStickerVC") as! TDCustomStickerVC
        let dic1 = stickerDic.validatedValue("script-quotes", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
        let whiteArray = dic1.validatedValue("white", expected: NSArray() as AnyObject) as! [Any]
        let blackArray = dic1.validatedValue("black", expected: NSArray() as AnyObject) as! [Any]
        stickerVC9.stickerArray = whiteArray + blackArray
        stickerVC9.screenType = .Quotes
        stickerVC9.delegate = self

        
        let tabVC = TabPageViewController.create()
         tabVC.isInfinity = true
        tabVC.setContentSize()
        tabVC.tabItems = [(stickerVC, "SMILEYS & PEOPLE"), (stickerVC1, "ANIMALS & NATURE"), (stickerVC2, "FOOD & DRINK"), (stickerVC3, "ACTIVITY"),(stickerVC4, "TRAVEL & PLACES"), (stickerVC5, "OBJECTS"), (stickerVC6, "SYMBOLS"), (stickerVC7, "FLAGS"), (stickerVC8, "FLOWERS"), (stickerVC9, "QUOTES")]
        var option = TabPageOption()
        option.currentColor = UIColor.white
        option.tabHeight = 50.0
        option.tabBackgroundColor = UIColor.clear
        tabVC.option = option
        
        tabVC.view.backgroundColor = UIColor.clear
    
        
        popUp = STPopupController(rootViewController: tabVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        popUp.navigationBarHidden = true
        popUp.style = STPopupStyle.bottomSheet
        popUp.transitionStyle = STPopupTransitionStyle.fade
        popUp.style = .bottomSheet
        
//        let cView = UIView(frame: CGRect(x: 0, y: kWindowHeight()-30, width: kWindowWidth(), height: 30))
//        cView.backgroundColor = RGBA(88.0, g: 88.0, b: 85.0, a: 1.0)
//        popUp.backgroundView.addSubview(cView)
        
        let image1 = UIImage(named: "whitePassIcon")
        let tagBtn : UIButton!
        tagBtn = UIButton()
        tagBtn.frame = CGRect(x: (kWindowWidth()-40)/2, y: 5, width: 40, height: 40)
        tagBtn.setImage(image1, for: .normal)
        tagBtn.addTarget(self, action: #selector(stickerBackAction), for: .touchUpInside)
        popUp.backgroundView.addSubview(tagBtn)

        
        popUp.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))

        popUp.present(in: self)
    }
    
    func stickerBackAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissPopup() {
        popUp.dismiss()
    }
    
    @IBAction func filterBtnAction(_ sender: UIButton) {
        
//        if filterCollectionView.isHidden {
//            self.isHiddenButtonsOnEditing(true)
//            if !isSplitJournal {
//                filterBtn.isHidden = false
//            }
//            ScreenMode = .filter
//            blurImageView.isHidden = false
//
//        }else{
//            self.isHiddenButtonsOnEditing(false)
//            ScreenMode = .nothing
//            blurImageView.isHidden = true
//        }
//        filterCollectionView.isHidden = !filterCollectionView.isHidden
    }
    
    @IBAction func drawingBtnAction(_ sender: UIButton) {
       // mainDrawingView.isHidden = false
    }
    
    @IBAction func saveBtnAction(_ sender: UIButton) {
        
//        let stickerViewArray: NSArray = stickerViewDic.allValues as NSArray
//        let stickerImageArray: NSArray = stickerImageDic.allValues as NSArray
//        
//        print(stickerViewArray.count)
//        if stickerViewArray.count > 0{
//            
//            for i in 0..<stickerViewArray.count {
//                
//                let stickerImageView = stickerViewArray.object(at: i) as! UIImageView
//                var stickerImage = stickerImageArray.object(at: i) as! UIImage
//                
//                stickerImage = self.imageResize(stickerImage, andResizeTo: CGSize(width: stickerImageView.frame.size.width, height: stickerImageView.frame.size.height))
//                let radians: CGFloat = CGFloat(atan2f(Float(stickerImageView.transform.b), Float(stickerImageView.transform.a)))
//                stickerImage = self.rotateImage(stickerImage, byRadian: radians)
//                self.journalImage = self.imageResize(self.journalImage, andResizeTo: CGSize(width: kWindowWidth(), height: kWindowHeight()))
//                self.journalImage = self.draw(stickerImage, in: self.journalImage, atPoint: stickerImageView.frame)
//            }
//        }
        
    }
    
    
    func imageResize(_ img: UIImage, andResizeTo newSize: CGSize) -> UIImage {
        let scale: CGFloat = UIScreen.main.scale
        /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
        //UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        img.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newSize.width), height: CGFloat(newSize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func rotateImage(_ src: UIImage, byRadian radian: CGFloat) -> UIImage {
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(src.size.width), height: CGFloat(src.size.height)))
        let t = CGAffineTransform(rotationAngle: radian)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext? = UIGraphicsGetCurrentContext()
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //   // Rotate the image context
        bitmap?.rotate(by: radian)
        // Now, draw the rotated/scaled image into the context
        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(src.cgImage!, in: CGRect(x: CGFloat(-src.size.width / 2), y: CGFloat(-src.size.height / 2), width: CGFloat(src.size.width), height: CGFloat(src.size.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func draw(_ fgImage: UIImage, in bgImage: UIImage, atPoint point: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bgImage.size, false, 0.0)
        bgImage.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(bgImage.size.width), height: CGFloat(bgImage.size.height)))
        print("\(fgImage.size.width)\(fgImage.size.height)")
        // [fgImage drawInRect:stickerView.frame];
        fgImage.draw(in: point)
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    
    //MARK:- Sticker Selection Dekegate
    
    func selectedSticker(selectedImage: UIImage, screenType: String) {
        
        let stickerView: UIImageView
        
//        if screenType == "EMOJI" {
//            stickerView = UIImageView.init(frame: CGRect(x: (kWindowWidth()-150)/2, y: (kWindowHeight()-150)/2, width: 150, height: 150))
//
//        }else if screenType == "QUOTES"{
//            
//            stickerView = UIImageView.init(frame: CGRect(x: (kWindowWidth()-300)/2, y: (kWindowHeight()-300)/2, width: 300, height: 300))
//        }
//        else{
//            
//            stickerView = UIImageView.init(frame: CGRect(x: (kWindowWidth()-selectedImage.size.width)/2, y: (kWindowHeight()-selectedImage.size.height)/2, width: selectedImage.size.width, height: selectedImage.size.height))
//        }
        stickerView = UIImageView.init(frame: CGRect(x: (kWindowWidth()-150)/2, y: (kWindowHeight()-150)/2, width: 150, height: 150))

       
        stickerView.image = selectedImage
        stickerView.isUserInteractionEnabled = true
        stickerView.tag = stiCount
        
        stickerViewDic.setObject(stickerView, forKey: stiCount as NSCopying)
        stickerImageDic.setObject(selectedImage, forKey: stiCount as NSCopying)
        stiCount += 1
        
        filterSwitcherView.addSubview(stickerView)
        filterSwitcherView.bringSubview(toFront: stickerView)
        
        let longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressActionOnSticker(_:)))
        stickerView.addGestureRecognizer(longGesture)
        
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(pinchActionOnSticker(_:)))
        pinchGesture.delegate = self
        stickerView.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(rotationActionOnSticker(_:)))
        rotationGesture.delegate = self
        stickerView.addGestureRecognizer(rotationGesture)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panActionOnSticker(_:)))
        panGesture.delegate = self
        stickerView.addGestureRecognizer(panGesture)

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        return true
    }
    
    //MARK:- UIGesture Actions on Sticker
    
    func longPressActionOnSticker(_ longGesture: UILongPressGestureRecognizer) {
        
        let longGestureState = longGesture.state
        if longGestureState == .began || longGestureState == .changed {
            
            let stickerTag: Int = (longGesture.view?.tag)!
            
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelActionButton)
            
            let actionButton: UIAlertAction = UIAlertAction(title: "Delete Sticker", style: .default)
            { action -> Void in
                
                let stickerView = self.stickerViewDic.object(forKey: stickerTag as NSCopying) as! UIImageView
                stickerView.removeFromSuperview()
                self.stickerViewDic.removeObject(forKey: stickerTag as NSCopying)
            }
            actionSheetController.addAction(actionButton)
            
            self.present(actionSheetController, animated: true, completion: nil)
            
        }
    }
    
    func pinchActionOnSticker(_ pinchGesture: UIPinchGestureRecognizer) {
        
        let pinchGestureState = pinchGesture.state
        if pinchGestureState == .began || pinchGestureState == .changed {
            
            let scale:CGFloat = pinchGesture.scale
            pinchGesture.view?.transform = (pinchGesture.view?.transform)!.scaledBy(x: scale, y: scale);
            pinchGesture.scale = 1.0
        }
    }
    
     func rotationActionOnSticker(_ rotationGesture: UIRotationGestureRecognizer) {
        
        if rotationGesture.state == .cancelled {
            lastRotation = 0.0
            return
        }
        let rotation:CGFloat = 0.0 - (lastRotation - rotationGesture.rotation)
        
        let currentTransform: CGAffineTransform = (rotationGesture.view!.transform)
        let newTransform: CGAffineTransform = currentTransform.rotated(by: rotation)
        
        rotationGesture.view?.transform = newTransform
        lastRotation = rotationGesture.rotation
        
    }
    
    func panActionOnSticker(_ recognizer: UIPanGestureRecognizer) {
        
        let translation:CGPoint = recognizer.translation(in: self.view)
        
        recognizer.view?.center = CGPoint(x: (recognizer.view?.center.x)! + translation.x, y: (recognizer.view?.center.y)! + translation.y)
        recognizer.setTranslation(CGPoint(x: 0.0, y: 0.0), in: self.view)
        
        if recognizer.state == .began {
            
        }else if recognizer.state == .ended{
            
        }
        
    }
    
    //MARK:- UITextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView){
        blurImageView.isHidden = false
        ScreenMode = .editing
        blurImageView.backgroundColor = UIColor.black
        countLbl.isHidden = false
        textView.isHidden = false
        self.isHiddenButtonsOnEditing(true)
        if isEditTitle {
            countLbl.text = "TITLE\n \(textView.text.length) / 50"
        }else{
            countLbl.text = "CONTEXT\n \(textView.text.length) / 400"
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        
        if isEditTitle {
            suggestionTextViewHeightConstraint.constant = CGFloat(textView.text.setHeightWithText(strText: textView.text, width: 20, fontName: kAppFontRegularWithSize(23))+20)
        }else{
            
            if CGFloat(textView.text.setHeightWithText(strText: textView.text, width: 20, fontName: kAppFontRegularWithSize(23))+25) <=  kWindowHeight() - journalTextViewBottomConstraint.constant-70 {
                textView.isScrollEnabled = false
                textView.showsVerticalScrollIndicator = false
                journalTextViewHeightConstraint.constant = CGFloat(textView.text.setHeightWithText(strText: textView.text, width: 20, fontName: kAppFontRegularWithSize(23))+25)
            }else{
                textView.isScrollEnabled = true
                textView.showsVerticalScrollIndicator = true
                journalTextViewHeightConstraint.constant = kWindowHeight() - journalTextViewBottomConstraint.constant-70
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
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
        
        if isEditTitle {
            if trimWhiteSpace(textView.text).length > 0 {
                suggestionLbl.text = trimWhiteSpace(textView.text)
                suggestionLblHeightConstraint.constant = CGFloat((suggestionLbl.text?.setHeightWithText(strText: suggestionLbl.text!, width: 28, fontName: kAppFontBoldWithSize(14)))!)
            }else{
                suggestionLbl.text = "TAP HERE TO TITLE THIS MOMENT."
                suggestionLblHeightConstraint.constant = 21
            }
            
        }else{
            
            if trimWhiteSpace(textView.text).length > 0 {
                journalLbl.text = trimWhiteSpace(textView.text)
                journalLblHeightConstraint.constant = CGFloat(((journalLbl.text?.setHeightWithText(strText: journalLbl.text!, width: 28, fontName: kAppFontItalicWithSize(22)))!+10))
            }else{
                journalLbl.text = "Type something here."
                journalLblHeightConstraint.constant = 25
            }
            
        }
        blurImageView.backgroundColor = UIColor.clear
        blurImageView.isHidden = true
        countLbl.isHidden = true
        textView.isHidden = true
        ScreenMode = .nothing
        isEditTitle = false
        self.isHiddenButtonsOnEditing(false)
        
    }
    
    //MARK:- UICollection View DataSource and Delegate Methods
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
       
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDFilterCollectionCell", for: indexPath) as! TDFilterCollectionCell
            var filteredImage = journalImage
            if indexPath.row != 0 {
                filteredImage = createFilteredImage(filterNameList[indexPath.row], image: journalImage!)
            }
            
            cell.filterImageView.image = filteredImage
            
            cell.textLbl.text = filterDisplayNameList[indexPath.row]
            cell.tickImage.isHidden = true
            cell.filterLbl.backgroundColor = UIColor.clear
            cell.textLbl.textColor = UIColor(white: 1.0, alpha: 0.8)
            cell.filterLbl.layer.borderWidth = 0.0
            
            if selectedFilterName == filterDisplayNameList[indexPath.row]{
                cell.filterLbl.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
                cell.textLbl.textColor = UIColor(white: 1.0, alpha: 1.0)
                cell.filterLbl.layer.borderColor = UIColor.white.cgColor
                cell.filterLbl.layer.borderWidth = 2.0
                cell.tickImage.isHidden = false
            }
            
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
            return CGSize(width: 50, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            selectedFilterName = filterDisplayNameList[indexPath.row]
            applyFilterWithFlag(isFirst: true, withIndex: indexPath.item)
            self.filterCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(0, 160, 0, 0);
    }

    
    
    //MARK:- Create Filtered Image Methods
    
    func createFilteredImage(_ filterName: String, image: UIImage) -> UIImage {
        // 1 - create source image
        let sourceImage = CIImage(image: image)
        
        // 2 - create filter using name
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        
        // 3 - set source image
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        
        // 5 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!)
        
        return filteredImage
    }
    
    func resizeImage(_ image: UIImage) -> UIImage {
        let ratio: CGFloat = 0.3
        let resizedSize = CGSize(width: Int(image.size.width * ratio), height: Int(image.size.height * ratio))
        UIGraphicsBeginImageContext(resizedSize)
        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    
    func applyFilterWithFlag(isFirst:Bool, withIndex:NSInteger) {
        
        let filterName = filterNameList[withIndex]
        
        if let image = self.motionView.image {
            var filteredImage = journalImage
            if withIndex != 0 {
                filteredImage = createFilteredImage(filterName, image: filteredImage!)
            }
            self.motionView.image = filteredImage
        }
    }
    
    //MARK:- Drawing Working Methods
    
    @IBAction func drawingBackBtnAction(_ sender: UIButton) {
        
        mainDrawingView.isHidden = true
    }
    
    @IBAction func drawingBtnViewAction(_ sender: UIButton) {
        mainDrawingView.isHidden = true
    }
    
    @IBAction func drawingUndoBtnAction(_ sender: UIButton) {
        
    }
    
    
    
    //MARK:- WebService Methods
    
    func callWebApiForGetStickers() {
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kStickers) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                if let status = dic["success"] as? Bool {
                    if status {
                        self.stickerDic = dic.validatedValue("stickers", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                        //print(stickerDic)
                        
                    }
                }
            }
        }
    }


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
