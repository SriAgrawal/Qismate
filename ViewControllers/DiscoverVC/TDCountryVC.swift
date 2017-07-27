//
//  TDCountryVC.swift
//  Qismet
//
//  Created by Lalit on 11/04/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit

protocol CountrySelectDelegate:class {
    
    func selectedCountry( country : String);
}

class TDCountryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var countryTableView: UITableView!
    
    weak var delegate:CountrySelectDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
    }
    
    
    //MARK:- UITableView Delegate and DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:CountryTableCell = tableView.dequeueReusableCell(withIdentifier: "CountryTableCell", for: indexPath) as! CountryTableCell
        let obj = countryList.object(at: indexPath.row) as! TDCountryList
        cell.selectionStyle = .none
        cell.countryLbl.text = obj.countryName
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 70    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = tableView.cellForRow(at: indexPath) as! CountryTableCell
        self.delegate?.selectedCountry(country: cell.countryLbl.text!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setContentSize(){
        self.contentSizeInPopup = CGSize(width: kWindowWidth()-50, height: 420)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
