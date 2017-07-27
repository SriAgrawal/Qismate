//
//  TDCustomStickerVC.swift
//  Qismet
//
//  Created by Lalit on 31/03/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

protocol StickerDelegate:class {
    
    func selectedSticker( selectedImage : UIImage, screenType: String);
}

enum ScreenType {
    case Smileys,Animal,Food,Activity,Travel,Object,Symbol,Flag,Flower,Quotes
}


class TDCustomStickerVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    @IBOutlet weak var stickerCollectionBottomConstraint: NSLayoutConstraint!
    
    weak var delegate:StickerDelegate?
    var bottomArray = NSMutableArray()
    var stickerArray = [Any]()
    var stickerDic: Dictionary<String, Any>!
    var isBackAction:Bool = false
    var screenType = ScreenType.Smileys
    
    //MARK:- View Life Cyle Implemenation Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDefaults()

    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let scrollBar = TOScrollBar()
        stickerCollectionView.to_add(scrollBar)
        stickerCollectionView.to_scrollBar?.isHidden = true
        
        stickerCollectionView.delegate = self
        stickerCollectionView.dataSource = self


    }
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        stickerCollectionView.to_scrollBar?.removeFromScrollView()
    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults() {
        
//        bottomCollectionView.delegate = self
//        bottomCollectionView.dataSource = self

//        let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
//        stickerArray = dic.validatedValue("people", expected: NSArray() as AnyObject) as! [Any]
        
//        let imageArr = ["faceIcon","catIcon","foodIcon","ballIcon","carIcon","phoneIcon","clockIcon","flagIcon","flowerIcon","featherIcon"] as NSArray
//        for i in 0..<imageArr.count {
//            let obj = TDStickerList()
//            if i == 0 {
//                obj.isSelected = true
//            }else{
//                obj.isSelected = false
//            }
//            obj.icon = UIImage(named: imageArr[i] as! String)!
//            bottomArray.add(obj)
//        }
        
        
        self.stickerCollectionView.backgroundColor = RGBA(88.0, g: 88.0, b: 85.0, a: 1.0).withAlphaComponent(0.5)
//        self.stickerCollectionView.layer.cornerRadius = 15.0
//        self.stickerCollectionView.clipsToBounds = true
    }
    
    func setContentSize(){
        self.contentSizeInPopup = CGSize(width: kWindowWidth(), height: kWindowHeight())
    }

    
    //MARK:- UICollectionView DataSource and Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == bottomCollectionView {
            return bottomArray.count;
        }
        return stickerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        if collectionView == bottomCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCollectionCell", for: indexPath) as! StickerCollectionCell
            let obj = bottomArray[indexPath.row] as! TDStickerList
            if obj.isSelected {
                cell.stickerImageView.alpha = 1.0
            }else{
                cell.stickerImageView.alpha = 0.4
            }
            cell.stickerImageView.image = obj.icon
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCollectionCell", for: indexPath) as! StickerCollectionCell
            let urlStr: String = stickerArray[indexPath.row] as! String
            cell.stickerImageView.sd_setImage(with: NSURL.init(string: urlStr) as URL!, placeholderImage: nil)
            
            cell.layoutMargins = (collectionView.to_scrollBar?.adjustedTableViewCellLayoutMargins(forMargins: cell.layoutMargins, manualOffset: 0.0))!
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == bottomCollectionView {
            return CGSize(width: 50, height: 50)
        }else{
//            if screenType == .Quotes {
//                return CGSize(width: collectionView.frame.size.width/3 - 20, height: 120)
//            }
            return CGSize(width: collectionView.frame.size.width/3 - 30, height: collectionView.frame.size.width/3 - 30)
//            return CGSize(width: collectionView.frame.size.width/4 - 5 , height: collectionView.frame.size.width/4 - 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if collectionView == bottomCollectionView {
            for item in bottomArray {
                let obj = item as! TDStickerList
                obj.isSelected = false
            }
            let obj = bottomArray[indexPath.row] as! TDStickerList
            obj.isSelected = true
            stickerArray.removeAll()
            switch indexPath.row {
            case 0:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("people", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Smileys & People"
                break
            case 1:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("nature", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Animals & Nature"
            case 2:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("food", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Food & Drink"
            case 3:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("activity", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Activity"
            case 4:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("travel", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Travel & Places"
            case 5:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("objects", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Objects"
            case 6:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("symbols", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Symbols"
            case 7:
                let dic = stickerDic.validatedValue("twemoji", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("flags", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Flags"
            case 8:
                let dic = stickerDic.validatedValue("flowers", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("index", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Flowers"
            default:
                let dic = stickerDic.validatedValue("script-quotes", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
                stickerArray = dic.validatedValue("black", expected: NSArray() as AnyObject) as! [Any]
                titleLbl.text = "Quotes"

                break
            }
            bottomCollectionView .reloadData()
            stickerCollectionView.reloadData()
        }else{
            
            let cell = collectionView.cellForItem(at: indexPath) as! StickerCollectionCell
            self.delegate?.selectedSticker(selectedImage: cell.stickerImageView.image!, screenType: "asdf")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- UIButtonAction
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
        if scrollView == stickerCollectionView {
            if scrollView.isTracking {
                if scrollView.contentOffset.y > 20 {
                    stickerCollectionView.to_scrollBar?.isHidden = false
                }
            }else if scrollView.contentOffset.y == 0{
                stickerCollectionView.to_scrollBar?.isHidden = true
            }

        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
