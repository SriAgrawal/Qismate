//
//  TDCameraVC.swift
//  Qismet
//
//  Created by Suresh patel on 23/02/17.
//  Copyright © 2017 Qismet. All rights reserved.

import UIKit
import Photos

enum CameraModeType {
    case full, firstHalf, secondHalf
}

enum SuggestionType {
    case suggAdd, sugg, suggStar, suggHeart
}

var userProfile: TDUserList!
var settingPreferences = TDUserPreferences()
var countryList = NSMutableArray()
var selectedIdea:String = ""

//CGRect(x: 0, y: self.view.frame.size.height/2, width: 375, height: self.view.frame.size.height/2)

class TDCameraVC: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SwiftyCamViewControllerDelegate,STPopUpProtocol, SuggestionSelectDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var gallaryImageButton: UIButton!
    @IBOutlet weak var changePreviewButton: UIButton!
    @IBOutlet weak var captureButton: SwiftyRecordButton!
    
    @IBOutlet weak var backButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var flashBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var flipCameraTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomAddButton: UIButton!
    @IBOutlet weak var bottomSuggButton: UIButton!
    @IBOutlet weak var bottomStarButton: UIButton!
    @IBOutlet weak var bottomHeartButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var avtarImageView: UIImageView!
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var suggestionBtn: UIButton!
    @IBOutlet weak var arrowUpBtn: UIButton!
    
    @IBOutlet weak var journalBtn: UIButton!
    
    @IBOutlet weak var progressView: MRCircularProgressView!
    @IBOutlet weak var suggLabelCount: UILabel!
    @IBOutlet weak var countLabel: UILabel!


    @IBOutlet weak var blureView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var suggTableView: UITableView!
    
    @IBOutlet weak var suggCollectionView: UICollectionView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var bottpmCollectionView: UICollectionView!
    
    @IBOutlet weak var topCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var suggestionTextView: UITextView!
    
    var rootViewController: TDHomeVC?

    var firstImageView: UIImageView!
    var secondImageView: UIImageView!
    var firstGradientImageView: UIImageView!
    var secondGradientImageView: UIImageView!

    var firstImage = UIImage(named:"photoIconRed")
    var secondImage = UIImage(named:"photoIconRed")

    var isSingleView = true
    var isNext = true
    var isBefor = true
    var isSuggestionPopup:Bool = false

    var camViewController : SwiftyCamViewController!
    var cameraMode = CameraModeType.full
    var suggestionType = SuggestionType.suggAdd
    
    var suggestionArrayList = [String]()
    var firstSelectedFilterName = "Original"
    var secondSelectedFilterName = "Original"

    let placeholderText = "TAP HERE TO ADD A TITLE."
    
    var panGestureRecognizer:UIPanGestureRecognizer!
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    var popUp : STPopupController!

    
    fileprivate let context = CIContext(options: nil)

    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.hidesBackButton = true

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        PHPhotoLibrary.requestAuthorization { status in
//            switch status {
//            case .authorized:
//                
//                self.loadLastImageThumb { (image) in
//                    DispatchQueue.main.async(execute: {
//                        self.gallaryImageButton.setImage(image, for: UIControlState())
//                    })
//                }
//
//            case .restricted:
//                break
//            case .denied:
//                break
//            default:
//                // place for .notDetermined - in this callback status is already determined so should never get here
//                break
//            }
//        }
        
    }
    
    func setupDefaults(){
    
        self.createCameraViewWithFlag(isCreate: true, isRemove: false)
        addGallaryButtons()
      //  self.buttomButtonsAction(self.bottomAddButton)
        
        let tapOnCount = UITapGestureRecognizer(target: self, action:#selector(tapOnCountAction))
        suggLabelCount.addGestureRecognizer(tapOnCount)
        
        let tapOnAvtar = UITapGestureRecognizer(target: self, action:#selector(tapOnAvtarAction))
        avtarImageView.addGestureRecognizer(tapOnAvtar)

        
        self.progressView.progressColor = UIColor.white
        self.progressView.wrapperColor = UIColor.darkGray
        self.progressView.wrapperArcWidth = 1.5
        self.progressView.progressArcWidth = 1.5
        self.progressView.backgroundColor = UIColor.clear
        self.topCollectionViewConstraint.constant = kWindowHeight()/2-70
        self.bottomCollectionViewConstraint.constant = 0
        self.topCollectionView.isHidden = true
        self.bottpmCollectionView.isHidden = true
        self.topCollectionView.backgroundView = UIView()
        self.bottpmCollectionView.backgroundView = UIView()
//        self.topCollectionView.backgroundView?.layer.insertSublayer(self.createGradientLayer(), at: 0)
//        self.bottpmCollectionView.backgroundView?.layer.insertSublayer(self.createGradientLayer(), at: 0)
        
        self.view.bringSubview(toFront: flashButton)
       // self.view.bringSubview(toFront: backButton)
        self.view.bringSubview(toFront: flipCameraButton)
        self.view.bringSubview(toFront: gallaryImageButton)
        self.view.bringSubview(toFront: changePreviewButton)
        
        self.makeWebApiGetProfileWithInfo()
        
        avtarImageView.layer.borderWidth = 2.0
        
//        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
//        self.view.addGestureRecognizer(panGestureRecognizer)
        
        let notificationName = Notification.Name("CameraWillAppear")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshScreen), name: notificationName, object: nil)
    }
    
    func refreshScreen(){
        
        
        UIApplication.shared.isStatusBarHidden = true
        UIApplication.shared.statusBarStyle = .default

    }
    
    func createGradientLayer() -> CAGradientLayer {
        
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.topCollectionView.bounds
        gradientLayer.colors = [UIColor(white: 0.2, alpha: 0.4).cgColor, UIColor.darkGray.withAlphaComponent(0.3)]
        return gradientLayer
    }
    
    func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: 0,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 200 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }

    func createCameraViewWithFlag(isCreate:Bool, isRemove:Bool){
        
        DispatchQueue.main.async(execute: {
            if isRemove {
                
               // self.backButton.isHidden = true
                self.captureButton.isHidden = true
                self.flipCameraButton.isHidden = true
                self.flashButton.isHidden = true
                self.changePreviewButton.isHidden = true
                self.chatButton.isHidden = true
                self.avtarImageView.isHidden = true
                self.discoverButton.isHidden = true
            }
            let rect : CGRect!
            switch self.cameraMode {
            case CameraModeType.full:
                
                rect = self.view.bounds
                break
                
            case CameraModeType.firstHalf:
                rect = CGRect(x: 0, y: 0, width: kWindowWidth(), height: self.view.frame.size.height/2)
                break
                
            default:
                rect = CGRect(x: 0, y: self.view.frame.size.height/2, width: kWindowWidth(), height: self.view.frame.size.height/2)
                break
            }
            
            if isCreate{
                self.camViewController = SwiftyCamViewController(frame: rect)
                self.camViewController.cameraDelegate = self
                self.camViewController.maximumVideoDuration = 10.0
                self.camViewController.allowBackgroundAudio = false
                self.captureButton.delegate = self.camViewController
                self.view.addSubview(self.camViewController.view)
            }
            else{
                self.camViewController.updateCameraFrame(frame: rect)
            }
            self.view.sendSubview(toBack: self.camViewController.view)
           // self.view.bringSubview(toFront: self.backButton)
            self.view.bringSubview(toFront: self.captureButton)
            self.view.bringSubview(toFront: self.flashButton)
            self.view.bringSubview(toFront: self.flipCameraButton)
            self.view.bringSubview(toFront: self.changePreviewButton)
            self.view.bringSubview(toFront: self.chatButton)
            self.view.bringSubview(toFront: self.gallaryImageButton)
            self.filterButton.isHidden = true
            self.nextButton.isHidden = true

            self.addButtons()
            self.addBackButtons()
        })
    }
    
    func loadLastImageThumb(completion: @escaping (UIImage) -> ()) {
        let imgManager = PHImageManager.default()
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 1
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if let last = fetchResult.lastObject {
            let scale = UIScreen.main.scale
            let size = CGSize(width: 100 * scale, height: 100 * scale)
            let options = PHImageRequestOptions()
            
            imgManager.requestImage(for: last, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: { (image, _) in
                if let image = image {
                    completion(image)
                }
            })
        }
    }
    
    func toMerge(_ firstImage: UIImage, secondImage: UIImage) -> UIImage {
        let size = CGSize(width: CGFloat(kWindowWidth()), height: CGFloat(kWindowHeight()))
        UIGraphicsBeginImageContext(size)
        firstImage.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height / 2)))
        secondImage.draw(in: CGRect(x: CGFloat(0), y: CGFloat(kWindowHeight() / 2), width: CGFloat(size.width), height: CGFloat(size.height / 2)))
        let finalImage1: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage1!
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
    
    //MARK:- UITextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if !(secondImageView == nil){
            filterButton.isHidden = true
            nextButton.isHidden = true
        }
      //  self.backButton.isHidden = true
        self.flashButton.isHidden = true
        self.flipCameraButton.isHidden = true
        self.suggCollectionView.isHidden = true
        self.avtarImageView.isHidden = true
        self.discoverButton.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if !(secondImageView == nil) {
            filterButton.isHidden = false
            nextButton.isHidden = false
        }
     //   self.backButton.isHidden = false
        self.flashButton.isHidden = false
        self.flipCameraButton.isHidden = false
        self.avtarImageView.isHidden = false
        self.discoverButton.isHidden = false
        self.blureView.isHidden = true
        self.suggCollectionView.isHidden = false
        self.view.bringSubview(toFront: self.suggCollectionView)
        if trimWhiteSpace(textView.text) == "" {
            suggestionArrayList = [self.placeholderText]
        }
        else{
            suggestionArrayList = [trimWhiteSpace(textView.text)]
        }
        self.suggCollectionView.reloadData()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
        }
        let result = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) ?? text
        if result.length<=50 {
            countLabel.text = "TITLE\n\(result.length)/50"
        }
        else{
            return false
        }
        return true
    }
    
    //MARK:- SwiftyCamViewController Delegate Methods

    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
        
        switch cameraMode {
        case CameraModeType.full:
            
            let journalVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCreateJournalVC") as! TDCreateJournalVC
//            journalVC.journalImage = self.resizeImage(photo, andResizeTo: CGSize(width: kWindowWidth(), height: kWindowHeight()))
            journalVC.journalImage = self.normalizedImage(from: photo)
            
            // Add title
            
//            if !self.suggCollectionView.isHidden {
//                
//                let index = self.suggCollectionView.contentOffset.x/kWindowWidth()
//                let indexPath = NSIndexPath.init(row: Int(index), section: 0)
//                let suggCell = self.suggCollectionView.cellForItem(at: indexPath as IndexPath) as! TDSuggestionsCell
//                
//                journalVC.customTitle = trimWhiteSpace(suggCell.suggestionLbl.text!)
//                
//            }
            
            if selectedIdea.length > 0 {
                journalVC.customTitle = selectedIdea
            }
            
            let transition = DMAlphaTransition()
            journalVC.transitioningDelegate = transition
            self.present(journalVC, animated: true, completion: nil)
            break
            
        case CameraModeType.firstHalf:
            
            cameraMode = CameraModeType.secondHalf
            self.camViewController.switchCamera()
            self.createCameraViewWithFlag(isCreate: false, isRemove: true)

            
            firstImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2))
//            firstImageView.image = resizeImage(photo, andResizeTo: CGSize(width: kWindowWidth(), height: kWindowHeight()/2))
            
            cropImage(image: photo, toRect: CGRect(x: 0, y: 0, width: kWindowWidth()*10, height: kWindowHeight()*10))
//            firstImage = resizeImage(photo, andResizeTo: CGSize(width: kWindowWidth(), height: kWindowHeight()/2))
       //     firstImageView.image = photo.resizeImage(CGSize(width: kWindowWidth(), height: kWindowHeight()/2))
            firstImageView.contentMode = .scaleToFill
            firstImageView.clipsToBounds = true
            self.view.addSubview(firstImageView)
            
            firstGradientImageView = UIImageView(frame: CGRect(x: 0, y: (self.view.frame.size.height/2)/2, width: self.view.frame.size.width, height: (self.view.frame.size.height/2)/2))
           // firstGradientImageView.backgroundColor = UIColor.red
            firstGradientImageView.image = UIImage(named: "Bottomtrans")
            self.view.addSubview(firstGradientImageView)
            
            self.suggCollectionView.isHidden = true
            break
            
        default:
            cameraMode = CameraModeType.firstHalf
            secondImageView = UIImageView(frame: CGRect(x: 0, y: self.view.frame.size.height/2, width: self.view.frame.size.width, height: self.view.frame.size.height/2))
            secondImageView.contentMode = .scaleAspectFill
            secondImageView.image = resizeImage(photo, andResizeTo: CGSize(width: kWindowWidth(), height: kWindowHeight()/2))
            secondImageView.clipsToBounds = true
            self.view.addSubview(secondImageView)
            
            secondGradientImageView = UIImageView(frame: CGRect(x: 0, y: kWindowHeight() - (self.view.frame.size.height/2)/2, width: self.view.frame.size.width, height: (self.view.frame.size.height/2)/2))
           // secondGradientImageView.backgroundColor = UIColor.red
            secondGradientImageView.image = UIImage(named: "Bottomtrans")
            self.view.addSubview(secondGradientImageView)

            secondImage = resizeImage(photo, andResizeTo: CGSize(width: kWindowWidth(), height: kWindowHeight()/2))
            self.filterButton.isHidden = false
            self.nextButton.isHidden = false
            self.view.bringSubview(toFront: self.filterButton)
            self.view.bringSubview(toFront: self.nextButton)
            self.view.bringSubview(toFront: suggCollectionView)
            break
        }
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        
        print("Did Begin Recording")
        captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
//        let newVC = VideoViewController(videoURL: url)
//        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        swiftyCam.view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    

    //MARK:- UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == self.suggCollectionView {
            return self.suggestionArrayList.count;
        }
        else{
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if collectionView == self.suggCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDSuggestionsCell", for: indexPath) as! TDSuggestionsCell
            
            cell.suggestionLbl.text = self.suggestionArrayList[indexPath.item]
            return cell
        }
        else if collectionView == self.topCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDFilterCollectionCell", for: indexPath) as! TDFilterCollectionCell
            var filteredImage = firstImage
            if indexPath.row != 0 {
                filteredImage = createFilteredImage(filterNameList[indexPath.row], image: firstImage!)
            }
            cell.filterImageView.image = filteredImage

            cell.textLbl.text = filterDisplayNameList[indexPath.row]
            cell.tickImage.isHidden = true
            cell.filterLbl.backgroundColor = UIColor.clear
            cell.textLbl.textColor = UIColor(white: 1.0, alpha: 0.8)
            cell.filterImageView.layer.borderWidth = 0.0
            
            if firstSelectedFilterName == filterDisplayNameList[indexPath.row]{
                cell.filterLbl.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
                cell.textLbl.textColor = UIColor(white: 1.0, alpha: 1.0)
                cell.filterImageView.layer.borderColor = UIColor.white.cgColor
                cell.filterImageView.layer.borderWidth = 2.0
                cell.tickImage.isHidden = false
            }

            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDFilterCollectionCell", for: indexPath) as! TDFilterCollectionCell
            
            var filteredImage = secondImage
            if indexPath.row != 0 {
                filteredImage = createFilteredImage(filterNameList[indexPath.row], image: secondImage!)
            }
            
            cell.filterImageView.image = filteredImage

            cell.textLbl.text = filterDisplayNameList[indexPath.row]

            cell.tickImage.isHidden = true
            cell.filterLbl.backgroundColor = UIColor.clear
            cell.textLbl.textColor = UIColor(white: 1.0, alpha: 0.8)
            cell.filterImageView.layer.borderWidth = 0.0

            if secondSelectedFilterName == filterDisplayNameList[indexPath.row]{
                cell.filterLbl.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
                cell.textLbl.textColor = UIColor(white: 1.0, alpha: 1.0)
                cell.filterImageView.layer.borderColor = UIColor.white.cgColor
                cell.filterImageView.layer.borderWidth = 2.0
                cell.tickImage.isHidden = false
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == self.suggCollectionView {
            return CGSize(width: kWindowWidth(), height: 200)
        }else{
            return CGSize(width: 50, height: 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.suggCollectionView {
//            if suggestionType == SuggestionType.suggAdd {
//                self.blureView.isHidden = false
//                self.view.bringSubview(toFront: self.blureView)
//                self.suggestionTextView.becomeFirstResponder()
//                self.countLabel.text = "TITLE\n\(self.suggestionTextView.text.length)/50"
//            }
        }
        else if collectionView == self.topCollectionView{
            firstSelectedFilterName = filterDisplayNameList[indexPath.row]
            applyFilterWithFlag(isFirst: true, withIndex: indexPath.item)
            self.topCollectionView.reloadData()
        }
        else{
            secondSelectedFilterName = filterDisplayNameList[indexPath.row]
            applyFilterWithFlag(isFirst: false, withIndex: indexPath.item)
            self.bottpmCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.suggCollectionView {
            return UIEdgeInsetsMake(0, 0, 0, 0);
        }
        else{
            return UIEdgeInsetsMake(0, 160, 0, 0);
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetWhenFullyScrolledRight = kWindowWidth() * CGFloat((suggestionArrayList.count - 1))
        if scrollView.isTracking {
            isNext = false
            isBefor = false
            
            if self.suggCollectionView.contentOffset.x > contentOffsetWhenFullyScrolledRight + 20 {
                isNext = true
            }
            else if self.suggCollectionView.contentOffset.x < -20 {
                isBefor = true
            }
        }
        else if isNext {
            self.suggCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
        else if isBefor {
            self.suggCollectionView.setContentOffset(CGPoint(x: contentOffsetWhenFullyScrolledRight, y: 0), animated: false)
        }

        let index = self.suggCollectionView.contentOffset.x/self.suggCollectionView.bounds.size.width
        suggLabelCount.text = "\((suggestionArrayList.count - Int(index)))"
        self .setProgressBar(index: index+1)

    }

    func setProgressBar(index: CGFloat){
    
        let count = CGFloat(suggestionArrayList.count)
        progressView.setProgress(index/count, animated: true)
    }
    
    // MARK:- Suggestion Selected Delegate Methods
    
    func selectedSuggestion(selectedSugg: String) {
        popUp.dismiss(completion: {
            selectedIdea = selectedSugg
            self.suggestionArrayList = [selectedSugg]
            self.suggCollectionView.reloadData()
            self.suggCollectionView.isHidden = false
            self.isHiddenIcons(false)
            self.isSuggestionPopup = false
        })
    }

    // MARK:- UIButton IBAction Methods

//    @IBAction func suggestionBtnAction(_ sender: UIButton) {
//        
//        sender.isSelected = !sender.isSelected
//        progressView.isHidden = false
//        suggLabelCount.isHidden = false
//        
//        if sender.isSelected {
//            suggestionType = SuggestionType.suggStar
//            suggCollectionView.isHidden = false
//            self.suggestionArrayList = ["My favorite food.", "My favorite emoji.", "My favorite television show.", "My favorite movie.", "My favorite place.", "My favorite band/singer.", "My favorite song.", "My favorite store.", "My favorite book/author.", "My favorite sports team.", "My favorite actor/actress.","My greatest achievement.", "Most important event of my life so far.", "The person who has influenced me most.", "My greatest regret.", "The most evil thing I have ever done.", "The time I was most frightened.", "Most embarrassing thing ever to happen.", "If i could change one thing from my past.", "My best memory.", "My worst memory.","Truth or dare...", "I'm currently watching...", "Apple or Android...", "My dream car...", "My dream job...", "In ten years I will be...", "For a hobby, I...", "The craziest thing I ever did was...", "If I could travel anywhere new I would go...", "The thing that makes me the happiest is...", "The most important thing in my life is..."]
//            
//        }else{
//            suggestionType = SuggestionType.suggAdd
//            suggCollectionView.isHidden = true
//            progressView.isHidden = true
//            suggLabelCount.isHidden = true
//            self.suggestionArrayList = (trimWhiteSpace(self.suggestionTextView.text).length > 0) ? [trimWhiteSpace(self.suggestionTextView.text)] : [placeholderText]
//        }
//        self.setProgressBar(index: 1)
//        suggLabelCount.text = "\(self.suggestionArrayList.count)"
//        self.suggCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//        self.suggCollectionView.reloadData()
//    }
    
    @IBAction func arrowUpBtnAction(_ sender: UIButton) {
        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.middleVertScrollVc.scrollView.setContentOffset(CGPoint(x: 0.0, y: 2*kWindowHeight()), animated: true)

    }
    
    
    @IBAction func journalBtnAction(_ sender: UIButton) {
        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.scrollView.setContentOffset(CGPoint(x: kWindowWidth()*2, y: 0.0), animated: true)

    }
    
    
    @IBAction func suggestionBtnAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            let suggestionVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDSuggestionVC") as! TDSuggestionVC
            suggestionVC.delegate = self
            suggestionVC.setContentSize()
            
            popUp = STPopupController(rootViewController: suggestionVC)
            popUp.containerView.backgroundColor = UIColor.clear
            popUp.navigationBarHidden = true
            popUp.containerView.layer.cornerRadius = 5
            popUp.containerView.clipsToBounds = true
            popUp.delegate = self
            popUp.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
            popUp.backgroundView.backgroundColor = UIColor.clear
            popUp.transitionStyle = .fade
            
            isSuggestionPopup = true
            self.isHiddenIcons(true)
            self.captureButton.isHidden = false
            
            popUp.present(in: kAppDelegate.navController)
            
            let editButton = UIButton(frame: CGRect(x: (kWindowWidth()-40)/2, y: kWindowHeight()-90, width: 40, height: 40))
            editButton.addTarget(self, action: #selector(crossBtnAction), for: .touchUpInside)
            editButton.setImage(UIImage(named: "whitePassIcon"), for: .normal)
            popUp.backgroundView.addSubview(editButton)
            
            let arrowImage = UIImageView(frame: CGRect(x:(kWindowWidth()-15)/2, y: kWindowHeight()-125, width: 15, height: 10))
            arrowImage.image = UIImage(named:"downArrow")
            popUp.backgroundView.addSubview(arrowImage)
            popUp.backgroundView.sendSubview(toBack: arrowImage)

//            suggestionVC.modalPresentationStyle = .overFullScreen
//            self.present(suggestionVC, animated: false, completion: nil)
            
        }else{
            suggCollectionView.isHidden = true
            selectedIdea  = ""
        }
    }
    
    func crossBtnAction(){
        popUp.dismiss()
        isHiddenIcons(false)
        if isSuggestionPopup {
            isSuggestionPopup = false
            self.suggestionBtn.isSelected = !self.suggestionBtn.isSelected
        }
    }


    @IBAction func buttomButtonsAction(_ sender: UIButton){
        
        self.bottomAddButton.isSelected = false
       // self.bottomSuggButton.isSelected = false
       // self.bottomStarButton.isSelected = false
       // self.bottomHeartButton.isSelected = false
        progressView.isHidden = false
        suggLabelCount.isHidden = false

        sender.isSelected = true
        switch sender.tag {
        case 1000:
            suggestionType = SuggestionType.suggAdd
            progressView.isHidden = true
            suggLabelCount.isHidden = true
            self.suggestionArrayList = (trimWhiteSpace(self.suggestionTextView.text).length > 0) ? [trimWhiteSpace(self.suggestionTextView.text)] : [placeholderText]
            break
            
        case 1001:
            suggestionType = SuggestionType.sugg
            self.suggestionArrayList = ["My greatest achievement.", "Most important event of my life so far.", "The person who has influenced me most.", "My greatest regret.", "The most evil thing I have ever done.", "The time I was most frightened.", "Most embarrassing thing ever to happen.", "If i could change one thing from my past.", "My best memory.", "My worst memory."]
            break
            
        case 1002:
            suggestionType = SuggestionType.suggStar
            self.suggestionArrayList = ["My favorite food.", "My favorite emoji.", "My favorite television show.", "My favorite movie.", "My favorite place.", "My favorite band/singer.", "My favorite song.", "My favorite store.", "My favorite book/author.", "My favorite sports team.", "My favorite actor/actress.","My greatest achievement.", "Most important event of my life so far.", "The person who has influenced me most.", "My greatest regret.", "The most evil thing I have ever done.", "The time I was most frightened.", "Most embarrassing thing ever to happen.", "If i could change one thing from my past.", "My best memory.", "My worst memory.","Truth or dare...", "I'm currently watching...", "Apple or Android...", "My dream car...", "My dream job...", "In ten years I will be...", "For a hobby, I...", "The craziest thing I ever did was...", "If I could travel anywhere new I would go...", "The thing that makes me the happiest is...", "The most important thing in my life is..."]

            break
            
        default:
            suggestionType = SuggestionType.suggHeart
            self.suggestionArrayList = ["Truth or dare...", "I'm currently watching...", "Apple or Android...", "My dream car...", "My dream job...", "In ten years I will be...", "For a hobby, I...", "The craziest thing I ever did was...", "If I could travel anywhere new I would go...", "The thing that makes me the happiest is...", "The most important thing in my life is..."]

            break
        }
        self.setProgressBar(index: 1)
        suggLabelCount.text = "\(self.suggestionArrayList.count)"
        self.suggCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.suggCollectionView.reloadData()
    }

    @IBAction func cameraSwitchAction(_ sender: UIButton) {
        camViewController.switchCamera()
    }
    
    @IBAction func toggleFlashAction(_ sender: UIButton) {
        camViewController.flashEnabled = !camViewController.flashEnabled
        
        flashButton.isSelected = !flashButton.isSelected
    }
    
    @IBAction func changePreviewButtonAction(_ sender: UIButton) {
        
        if isSingleView{
            gallaryImageButton.isHidden = true
            cameraMode = CameraModeType.firstHalf
            self.createCameraViewWithFlag(isCreate: false, isRemove: false)
        }
        else{
            cameraMode = CameraModeType.full
            self.createCameraViewWithFlag(isCreate: false, isRemove: false)
            addGallaryButtons()
        }
        isSingleView = !isSingleView
        changePreviewButton.isSelected = !changePreviewButton.isSelected
    }
    
    @IBAction func gallaryButtonAction(_ sender: UIButton) {
        
//        let picker = UIImagePickerController()
//        picker.allowsEditing = false
//        picker.sourceType = .photoLibrary
//        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
//        picker.delegate = self
//        present(picker, animated: true, completion: nil)
        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)

    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        if !self.topCollectionView.isHidden{
            self.topCollectionView.isHidden = true
            self.bottpmCollectionView.isHidden = true
            return
        }
        
        switch cameraMode {
        case CameraModeType.full:
            self.dismiss(animated: true, completion: nil)
            break
            
        case CameraModeType.firstHalf:
            
            if backButtonLeftConstraint.constant == 10 {
                cameraMode = CameraModeType.secondHalf
                if let imageView = self.secondImageView {
                    imageView.removeFromSuperview()
                    self.secondGradientImageView.removeFromSuperview()
                    self.secondImageView = nil
                }
                self.createCameraViewWithFlag(isCreate: false, isRemove: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            
            break
            
        default:
            cameraMode = CameraModeType.firstHalf
            if let imageView = self.firstImageView {
                imageView.removeFromSuperview()
                self.firstGradientImageView.removeFromSuperview()
                self.firstImageView = nil
            }
            if let imageView = self.secondImageView {
                imageView.removeFromSuperview()
                self.secondGradientImageView.removeFromSuperview()
            }
            self.suggCollectionView.isHidden = false
            self.createCameraViewWithFlag(isCreate: false, isRemove: true)
            
            break
        }
    }
    
    @IBAction func blureViewBackAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        self.blureView.isHidden = true
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        
        if self.topCollectionView.isHidden {
            self.view.endEditing(true)
            self.topCollectionView.isHidden = false
            self.bottpmCollectionView.isHidden = false
            self.view.bringSubview(toFront: self.topCollectionView)
            self.view.bringSubview(toFront: self.bottpmCollectionView)
            self.topCollectionView.reloadData()
            self.bottpmCollectionView.reloadData()
        }else{
            self.topCollectionView.isHidden = true
            self.bottpmCollectionView.isHidden = true

        }

    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let journalVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCreateJournalVC") as! TDCreateJournalVC
        
        journalVC.journalImage = self.toMerge(firstImageView.image!, secondImage: secondImageView.image!)
        journalVC.isSplitJournal = true
        // Add title
        let index = suggCollectionView.contentOffset.x/kWindowWidth()
        let indexPath = NSIndexPath.init(row: Int(index), section: 0)
        let suggCell = suggCollectionView.cellForItem(at: indexPath as IndexPath) as! TDSuggestionsCell
        switch suggestionType {
            
        case .suggAdd:
            if suggCell.suggestionLbl.text == self.placeholderText {
                journalVC.customTitle = ""
            }else{
                journalVC.customTitle = trimWhiteSpace(suggCell.suggestionLbl.text!)
            }
            break
            
        default:
            journalVC.fixTitle = trimWhiteSpace(suggCell.suggestionLbl.text!)
            break
        }
        
        self.present(journalVC, animated: true, completion: nil)
    }
    
    
    @IBAction func discoverBtnAction(_ sender: UIButton) {
        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.middleVertScrollVc.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        
//        let tab = TDTabBarController()
//        self.present(tab, animated: true, completion: nil)
    }
    
    @IBAction func connectionBtnAction(_ sender: UIButton) {
        
        let loginVC = self.navigationController?.viewControllers[0] as! TDLoginVC
        loginVC.snapchatSwipeContainer.middleVertScrollVc.scrollView.setContentOffset(CGPoint(x: 0.0, y: 2*kWindowHeight()), animated: true)

    }
    


    func tapOnCountAction() {
        
        var index = self.suggCollectionView.contentOffset.x/self.suggCollectionView.bounds.size.width
        if index < CGFloat((suggestionArrayList.count - 1)) {
            index = index + 1
        }else {
            index = 0;
        }
        self.suggCollectionView.setContentOffset(CGPoint(x: index * kWindowWidth(), y: 0), animated: false)
    }
    
    func tapOnAvtarAction() {
        
        let popVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDProfilePopUp") as! TDProfilePopUp
        popVC.setContentSize()
        
        popUp = STPopupController(rootViewController: popVC)
        popUp.containerView.backgroundColor = UIColor.clear
        popUp.navigationBarHidden = true
        popUp.containerView.layer.cornerRadius = 5
        popUp.containerView.clipsToBounds = true
        popUp.delegate = self
        popUp.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        
        let editButton = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        editButton.addTarget(self, action: #selector(editBtnAction), for: .touchUpInside)
        editButton.setImage(UIImage(named: "profileEditIcon"), for: .normal)
        popUp.backgroundView.addSubview(editButton)
        
        let settingButton = UIButton(frame: CGRect(x: (kWindowWidth()-50), y: 10, width: 40, height: 40))
        settingButton.setImage(UIImage(named: "settingIcon"), for: .normal)
        settingButton.addTarget(self, action: #selector(settingBtnAction), for: .touchUpInside)
        popUp.backgroundView.addSubview(settingButton)
        
        self.isHiddenIcons(true)

        popUp.present(in: kAppDelegate.navController)
    }
    
    func editBtnAction(){
        self.isHiddenIcons(false)
        popUp.dismiss()
        let profileVC = storyboardForName(name: "Main").instantiateViewController(withIdentifier: "TDUserProfileVC") as! TDUserProfileVC
        self.present(profileVC, animated: true, completion: nil)
    }
    
    func settingBtnAction(){
        popUp.dismiss()
        self.isHiddenIcons(false)
        let settingVC = storyboardForName(name: "Home").instantiateViewController(withIdentifier: "TDSettingVC") as! TDSettingVC
        self.present(settingVC, animated: true, completion: nil)

    }
    
    func dismissPopup() {
        self.isHiddenIcons(false)
        popUp.dismiss()
        if isSuggestionPopup {
            isSuggestionPopup = false
            self.suggestionBtn.isSelected = !self.suggestionBtn.isSelected
        }
    }
    
    func isHiddenIcons(_ status:Bool) {
        
        bottomView.isHidden = status
        chatButton.isHidden = status
        avtarImageView.isHidden = status
        gallaryImageButton.isHidden = status
        suggestionBtn.isHidden = status
     //   backButton.isHidden = status
        flashButton.isHidden = status
        discoverButton.isHidden = status
        flipCameraButton.isHidden = status
        captureButton.isHidden = status
      //  changePreviewButton.isHidden = status
    }
    
    //MARK:- STPopup Delegate Methods
    
    func dismissPopUp() {
        self.isHiddenIcons(false)
        if isSuggestionPopup {
            isSuggestionPopup = false
            self.suggestionBtn.isSelected = !self.suggestionBtn.isSelected
        }
    }
    func onMovingPopup() {
        
    }
    func didFailDismissPopup() {
        
    }

    //MARK:- Add UIButton Methods

    private func addButtons() {
        
        captureButton.isHidden = false
        flipCameraButton.isHidden = false
      //  backButton.isHidden = false
        flashButton.isHidden = false

        if cameraMode != CameraModeType.secondHalf {
           // changePreviewButton.isHidden = false
            chatButton.isHidden = false
            avtarImageView.isHidden = false
            discoverButton.isHidden = false
        }
    }
    
    private func addBackButtons() {
        
        self.bottomView.isHidden = false
        self.suggCollectionView.alpha = 1.0
        self.view.bringSubview(toFront: self.suggCollectionView)
        switch cameraMode {
        case CameraModeType.full:
            backButtonLeftConstraint.constant = view.frame.midX - 20
            //backButton.isSelected = false
           // flashBtnTopConstraint.constant = 8
           // flipCameraTopConstraint.constant = 8
           // panGestureRecognizer.isEnabled = true
            break
            
        case CameraModeType.firstHalf:
            backButtonLeftConstraint.constant = view.frame.midX - 20
           // backButton.isSelected = false
           // flashBtnTopConstraint.constant = 8
           // flipCameraTopConstraint.constant = 8
            //panGestureRecognizer.isEnabled = true
            break
            
        default:
            
            self.bottomView.isHidden = true
            backButtonLeftConstraint.constant = 10
           // panGestureRecognizer.isEnabled = false
          //  backButton.isSelected = true
         //   flashBtnTopConstraint.constant = kWindowHeight()-90
         //   flipCameraTopConstraint.constant = kWindowHeight()-90
           // self.buttomButtonsAction(self.bottomAddButton)
            break
        }
    }
    
    private func addGallaryButtons() {
        
        gallaryImageButton.isHidden = false
    }
    
    //MARK:- UIImagePickerController Delegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true) {
            
            let journalVC = storyboardForName(name: "Moments").instantiateViewController(withIdentifier: "TDCreateJournalVC") as! TDCreateJournalVC
            journalVC.journalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
           //  Add title
            
            if !self.suggCollectionView.isHidden {
                
                let index = self.suggCollectionView.contentOffset.x/kWindowWidth()
                let indexPath = NSIndexPath.init(row: Int(index), section: 0)
                let suggCell = self.suggCollectionView.cellForItem(at: indexPath as IndexPath) as! TDSuggestionsCell
                
                journalVC.customTitle = trimWhiteSpace(suggCell.suggestionLbl.text!)

                
            }
            let transition = DMAlphaTransition()
            journalVC.transitioningDelegate = transition
            self.present(journalVC, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
//    func resizeImage(_ image: UIImage) -> UIImage {
//        let ratio: CGFloat = 1.0
//        let resizedSize = CGSize(width: kWindowWidth() * ratio, height: kWindowHeight()/2 * ratio)
//       // UIGraphicsBeginImageContext(resizedSize)
//        UIGraphicsBeginImageContextWithOptions(resizedSize, false, UIScreen.main.scale)
//        image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return resizedImage!
//    }
    
    func resizeImage(_ img: UIImage, andResizeTo newSize: CGSize) -> UIImage {
        let scale: CGFloat = UIScreen.main.scale
        /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
        //UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        img.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newSize.width), height: CGFloat(newSize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    var cropArea:CGRect{
        get{
            let factor = self.firstImageView.image!.size.width/view.frame.width
            let scale = 1.0 as CGFloat
            let imageFrame = self.firstImageView.imageFrame()
            let x = imageFrame.origin.x * scale * factor
            let y = imageFrame.origin.y * scale * factor
            let width = imageFrame.width * scale * factor
            let height = imageFrame.height * scale * factor
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }

    
    func cropImage(image: UIImage, toRect: CGRect) {
        // Cropping is available trhough CGGraphics
        
        let croppedCGImage = firstImageView.image?.cgImage?.cropping(to: cropArea)
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        firstImageView.image = croppedImage

//        let cgImage :CGImage! = image.cgImage
//        let croppedCGImage: CGImage! = cgImage.cropping(to: cropArea)
//        return UIImage(cgImage: croppedCGImage)
    }
    
    func applyFilterWithFlag(isFirst:Bool, withIndex:NSInteger) {
        let filterName = filterNameList[withIndex]
        
        if isFirst {
            if self.firstImageView.image != nil {
                var filteredImage = firstImage
                if withIndex != 0 {
                    filteredImage = createFilteredImage(filterName, image: firstImage!)
                }
                self.firstImageView.image = filteredImage
            }
        }
        else{
            if self.secondImageView.image != nil {
                var filteredImage = secondImage
                if withIndex != 0 {
                    filteredImage = createFilteredImage(filterName, image: secondImage!)
                }
                self.secondImageView.image = filteredImage
            }
        }
    }
    
    //MARK:- Web Service Method For get Profile Data
    
    func makeWebApiGetProfileWithInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kviewUserProfile) { (result, error) in
            
            userProfile = TDUserList.modelFromDict(result as? Dictionary<String, AnyObject>)
            self.avtarImageView.sd_setImage(with: userProfile.avtarImgUrl)
            self.makeWebApiGetSettingsInfo()
        }
    }
    
    func makeWebApiGetSettingsInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kUserPreference) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if let status = dic["success"] as? Bool {
                    
                    if status {
                        settingPreferences =  TDUserPreferences.modelFromDict((dic.validatedValue(KPreference, expected: "" as AnyObject) as! Dictionary<String, AnyObject>))
                    }
                    self.makeWebApiGetCountryList()
                }
            }
        }
    }
    
    func makeWebApiGetCountryList(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: kUserCount) { (result, error) in
            
            if let dic = result as? Dictionary<String, AnyObject> {
                
                if let status = dic["success"] as? Bool {
                    
                    if status {
                        countryList.removeAllObjects()
                        countryList =  TDCountryList.modelFromDict(dic)
                    }
                }
            }
        }
    }


}

extension UIImageView{
    func imageFrame()->CGRect{
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }else{
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}



