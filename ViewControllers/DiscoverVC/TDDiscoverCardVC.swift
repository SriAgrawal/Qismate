//
//  TDDiscoverCardVC.swift
//  Qismet
//
//  Created by Lalit on 05/04/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import HFCardCollectionViewLayout

class TDDiscoverCardVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    var cardCollectionViewLayout: HFCardCollectionViewLayout?
    var cardTitleArray = [String]()
    
    //MARK:- View Life Cyle Implemenation Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDefaults()

    }
    
    //MARK:- Helper Methods
    
    func setUpDefaults(){
        
        
        if let cardLayout = self.cardCollectionView?.collectionViewLayout as? HFCardCollectionViewLayout {
            self.cardCollectionViewLayout = cardLayout
        }
        
        self.cardCollectionViewLayout?.cardHeadHeight = 80.0
        self.cardCollectionViewLayout?.cardMaximumHeight = 0
        self.cardCollectionViewLayout?.firstMovableIndex = 0
        self.cardCollectionViewLayout?.cardShouldExpandHeadHeight = true
        self.cardCollectionViewLayout?.cardShouldStretchAtScrollTop = true
        self.cardCollectionViewLayout?.bottomNumberOfStackedCards = 3
        self.cardCollectionViewLayout?.bottomStackedCardsShouldScale = true
        self.cardCollectionViewLayout?.bottomCardLookoutMargin = 10
        self.cardCollectionViewLayout?.bottomStackedCardsMaximumScale = 1.0
        self.cardCollectionViewLayout?.bottomStackedCardsMinimumScale = 0.94
        self.cardCollectionViewLayout?.spaceAtTopForBackgroundView = 10
        self.cardCollectionViewLayout?.spaceAtTopShouldSnap = true                          
        self.cardCollectionViewLayout?.spaceAtBottom = 0
        self.cardCollectionViewLayout?.scrollAreaTop = 120
        self.cardCollectionViewLayout?.scrollAreaBottom = 120
        self.cardCollectionViewLayout?.scrollShouldSnapCardHead = false
        self.cardCollectionViewLayout?.scrollStopCardsAtTop = true
        
        cardTitleArray = ["Featured","Newest","Distance","Country"]
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self

    }
    
    // MARK:- UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return cardTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCardCell", for: indexPath) as! DiscoverCardCell
        cell.titleLbl.text = cardTitleArray[indexPath.item]
        cell.contentView.backgroundColor = UIColor.white
        
        cell.cellTableView.delegate = self
        cell.cellTableView.dataSource = self
//        cell.cellTableView.estimatedRowHeight = 70;
//        cell.cellTableView.rowHeight = UITableViewAutomaticDimension

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        self.cardCollectionViewLayout?.revealCardAt(index: indexPath.item)
    }
    
    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:TDDiscoverCell = tableView.dequeueReusableCell(withIdentifier: "TDDiscoverCell", for: indexPath) as! TDDiscoverCell
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
