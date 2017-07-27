//
//  TDStickerVC.swift
//  Qismet
//
//  Created by Lalit on 24/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

enum StickerScreenType {
    case sticker,style, flowers,foodie, monster, twemoji, quotes, ideas
}

protocol StickerSelectDelegate:class {
    
    func selectedSticker( selectedImage : UIImage, screenType: String);
}

class TDStickerVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var stickerCollectionTopConstraint: NSLayoutConstraint!
    
    var photoArray = [Any]()
    var styleArray = [Any]()
    var customDataArray = [Any]()
    var customBlackArray = [Any]()
    var screenType = StickerScreenType.sticker
    weak var delegate:StickerSelectDelegate?
    var isWhite: Bool = true
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDefaults()
    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults() {
        
        stickerCollectionView.delegate = self
        stickerCollectionView.dataSource = self
        
        let layout = stickerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        photoArray = ["sticker1","sticker3","sticker4","sticker5","sticker2","sticker6","sticker7","sticker9","sticker10","sticker17","sticker19","sticker20","sticker21","sticker23","sticker24","sticker25"]
        
        styleArray = ["sticker35","sticker36","sticker37","sticker38"];
        
//        if self.title == "QUOTES" {
//            stickerCollectionTopConstraint.constant = 41
//            segmentControl.isHidden = false
//        }else{
            stickerCollectionTopConstraint.constant = 20
            segmentControl.isHidden = true
//        }
        
        
    }
    
    //MARK:- UICollectionView DataSource and Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        switch screenType {
            
        case .sticker:
            return photoArray.count
            
        case .style:
            return styleArray.count
            
        case .flowers:
            return customDataArray.count
            
        case .foodie:
            return customDataArray.count
        case .monster:
            return customDataArray.count
        case .twemoji:
            return customDataArray.count
        case .quotes:
            if isWhite {
                return customDataArray.count
            }else{
                return customBlackArray.count
            }
        case .ideas:
            if isWhite {
                return customDataArray.count
            }else{
                return customBlackArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCollectionCell", for: indexPath) as! StickerCollectionCell
        
        switch screenType {
            
        case .sticker:
            cell.stickerImageView.image = UIImage(named: photoArray[indexPath.row] as! String)
            break
        case .style:
            cell.stickerImageView.image = UIImage(named: styleArray[indexPath.row] as! String)
            break
        case .flowers:
            let urlStr: String = customDataArray[indexPath.row] as! String
            cell.stickerImageView.sd_setImage(with: NSURL.init(string: urlStr) as URL!, placeholderImage: nil)
            break
        case .foodie:
            let urlStr: String = customDataArray[indexPath.row] as! String
            cell.stickerImageView.sd_setImage(with: NSURL.init(string: urlStr) as URL!, placeholderImage: nil)
            break
        case .monster:
            let urlStr: String = customDataArray[indexPath.row] as! String
            cell.stickerImageView.sd_setImage(with: NSURL.init(string: urlStr) as URL!, placeholderImage: nil)
            break
        case .twemoji:
            let urlStr: String = customDataArray[indexPath.row] as! String
            cell.stickerImageView.sd_setImage(with: NSURL.init(string: urlStr) as URL!, placeholderImage: nil)
            break
        case .quotes:
            let urlStr: String
            if isWhite {
                urlStr = customDataArray[indexPath.row] as! String
            }else{
                urlStr = customBlackArray[indexPath.row] as! String
            }
            cell.stickerImageView.sd_setImage(with: NSURL.init(string: urlStr) as URL!, placeholderImage: nil)
            break
        case .ideas:
            let urlStr: String
            if isWhite {
                urlStr = customDataArray[indexPath.row] as! String
            }else{
                urlStr = customBlackArray[indexPath.row] as! String
            }
            cell.stickerImageView.sd_setImage(with: NSURL.init(string: urlStr) as URL!, placeholderImage: nil)
            break
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if self.title == "EMOJI" {
            return CGSize(width: collectionView.frame.size.width/7, height: 50)
        }else if self.title == "IDEAS"{
            return CGSize(width: collectionView.frame.size.width/3 - 30, height: 100)
        }else{
            return CGSize(width: collectionView.frame.size.width/3 - 30, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let cell = collectionView.cellForItem(at: indexPath) as! StickerCollectionCell
        self.delegate?.selectedSticker(selectedImage: cell.stickerImageView.image!, screenType: self.title!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StickerCollectionHeaderView", for:indexPath) as! StickerCollectionHeaderView

            if screenType == .twemoji {
                
                if (headerView.titleLbl) != nil {
                    headerView.titleLbl.text = "ACTIVITY"
                }
              // headerView.backgroundColor = UIColor.purple
            }
            return headerView
        }
        else{
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        if screenType == .twemoji {
            return CGSize(width: kWindowWidth(), height: 30)
        }else{
            return CGSize(width: kWindowWidth(), height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: kWindowWidth(), height: 0)
    }
    
    @IBAction func segmentBtnAction(_ sender: UISegmentedControl) {
        
        isWhite = !isWhite
        self.stickerCollectionView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
