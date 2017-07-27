//
//  TDTagsVC.swift
//  Qismet
//
//  Created by Lalit on 13/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

protocol TagsViewSelectDelegate:class {
    func selectedTagsData(selectedArray : Array<Any>, screenType : String);
}

class TDTagsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    var dataArray = NSMutableArray()
    var pastSelectedTags = [Any]()
    
    var screenType : String!
    
    weak var delegate:TagsViewSelectDelegate?
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
      //  dataArray = ["Hello1","Hello2","Hello3","Hello4","Hello5"];
       // dataArray  = TDTagList.modelFromDict(data:dataArray)
      //  print(dataArray.count)
        self.makeWebApiGetTagsWithInfo()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        var selectedArray = Array<Any>()
        
        for item in dataArray {
            
            let tagObj = item as! TDTagList
            if tagObj.isStatus {
                selectedArray.append(tagObj.title)
            }
        }
        self.delegate?.selectedTagsData(selectedArray: selectedArray, screenType: self.screenType)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:- UICollectionView Delegate and DataSource Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return dataArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCollectionCell", for: indexPath) as! TagsCollectionCell
        let obj = dataArray[indexPath.row] as! TDTagList
        cell.tagLbl.text  = obj.title
        if obj.isStatus {
            cell.backView.backgroundColor = UIColor.white
            cell.tagLbl.textColor = UIColor.black
        }else{
            cell.backView.backgroundColor = UIColor.darkGray
            cell.tagLbl.textColor = UIColor.white
        }
        cell.backView.layer.cornerRadius = 40
        cell.backView.clipsToBounds = true
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let obj = dataArray[indexPath.row] as! TDTagList
        obj.isStatus = !obj.isStatus
        self.tagCollectionView.reloadData()
    }
    
    func makeWebApiGetTagsWithInfo(){
        
        ServiceHelper.callAPIWithParameters([:], method:.get, apiName: ktags) { (result, error) in
            
            let dic = result as? Dictionary<String, AnyObject>
            let tagDic = dic?.validatedValue("tags", expected: "" as AnyObject) as! Dictionary<String, AnyObject>
            self.dataArray = TDTagList.modelFromDict(data: tagDic.validatedValue(self.screenType, expected: NSMutableArray() as AnyObject) as! NSMutableArray)
            
            for item in self.pastSelectedTags {
                
                let tag = item as! String
                for item1 in self.dataArray{
                    
                    let tagObj = item1 as! TDTagList
                    if tagObj.title == tag {
                        tagObj.isStatus = true
                    }
                }
            }
            self.tagCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
