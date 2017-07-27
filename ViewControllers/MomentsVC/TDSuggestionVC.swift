//
//  TDSuggestionVC.swift
//  Qismet
//
//  Created by Lalit on 20/03/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

protocol SuggestionSelectDelegate:class {
    
    func selectedSuggestion( selectedSugg : String);
}

class TDSuggestionVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var suggTableView: UITableView!
    
    weak var delegate:SuggestionSelectDelegate?
    var suggestionArrayList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        suggTableView.rowHeight = UITableViewAutomaticDimension
        suggTableView.estimatedRowHeight = 70
        
      //  suggTableView.contentInset = UIEdgeInsetsMake(kWindowHeight()/2, 0, kWindowHeight()/2, 0)

        self.suggestionArrayList = ["My favorite food.", "My favorite emoji.", "My favorite television show.", "My favorite movie.", "My favorite place.", "My favorite band/singer.", "My favorite song.", "My favorite store.", "My favorite book/author.", "My favorite sports team.", "My favorite actor/actress.","My greatest achievement.", "Most important event of my life so far.", "The person who has influenced me most.", "My greatest regret.", "The most evil thing I have ever done.", "The time I was most frightened.", "Most embarrassing thing ever to happen.", "If i could change one thing from my past.", "My best memory.", "My worst memory.","Truth or dare...", "I'm currently watching...", "Apple or Android...", "My dream car...", "My dream job...", "In ten years I will be...", "For a hobby, I...", "The craziest thing I ever did was...", "If I could travel anywhere new I would go...", "The thing that makes me the happiest is...", "The most important thing in my life is..."]

    }
    
    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return suggestionArrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:CountryTableCell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell", for: indexPath) as! CountryTableCell
        cell.selectionStyle = .none
        cell.countryLbl.text = self.suggestionArrayList[indexPath.item]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 70    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let cell = tableView.cellForRow(at: indexPath) as! CountryTableCell
        self.delegate?.selectedSuggestion(selectedSugg: cell.countryLbl.text!)
    

//        self.dismiss(animated: false, completion: {
//
//        })
        
        
    }
    
    func setContentSize(){
        self.contentSizeInPopup = CGSize(width: kWindowWidth()-50, height: 420)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
