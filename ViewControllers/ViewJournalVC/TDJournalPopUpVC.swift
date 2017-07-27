//
//  TDJournalPopUpVC.swift
//  Qismet
//
//  Created by Lalit on 21/02/17.
//  Copyright © 2017 Qismet. All rights reserved.

import UIKit
import MapKit
import CoreLocation

class TDJournalPopUpVC: UIViewController {
    
    @IBOutlet weak var journalImageView: UIImageView!
    @IBOutlet weak var journalMapView: MKMapView!
    @IBOutlet weak var photoLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    
    var objSelectedJournal = TDJournalList()
    var journalImage : UIImage!
    
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
        
        print(objSelectedJournal.location)
        let tempImgView = UIImageView()
        tempImgView.sd_setImage(with: objSelectedJournal.journalImageUrl, completed: { (image, error, type, url) in
            self.journalImageView.image = image
        })
        
        let address = objSelectedJournal.location
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                let coordinate:CLLocationCoordinate2D = placemark.location!.coordinate
                
                let point = MKPointAnnotation()
                point.coordinate = coordinate
                point.title = ""
                self.journalMapView.addAnnotation(point)
                
                self.journalMapView.setCenter(coordinate, animated: true)
                
                var region = MKCoordinateRegion()
                region.center.latitude = coordinate.latitude
                region.center.longitude = coordinate.longitude
                region.span.longitudeDelta = 1.99
                region.span.latitudeDelta = 1.99
                self.journalMapView.setRegion(region, animated: true)
            }
        })
        
        if objSelectedJournal.albumPhotoDate.length > 0 {
            photoLbl.text = objSelectedJournal.albumPhotoDate
        }else{
            photoLbl.text = ""
        }
        
        if objSelectedJournal.uploadImageLocation.length < 0 {
            self.locationLbl.text = ""
            self.photoLbl.frame = CGRect(x: CGFloat(0), y: CGFloat(213), width: CGFloat(kWindowWidth() - 80), height: CGFloat(18))
        }
        else if objSelectedJournal.uploadImageLocation.length > 0 && !(objSelectedJournal.uploadImageLocation == objSelectedJournal.location) {
            self.locationLbl.text = "\(objSelectedJournal.uploadImageLocation)"
        }
        else {
            self.locationLbl.text = ""
            self.photoLbl.frame = CGRect(x: CGFloat(0), y: CGFloat((kWindowWidth() / 2) - 20), width: CGFloat(kWindowWidth()), height: CGFloat(18))
        }

    }
    
    func setContentSize(){
        self.contentSizeInPopup = CGSize(width: kWindowWidth()-80, height: 480)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
