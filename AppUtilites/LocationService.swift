//
//  LocationService.swift
//  Template
//
//  Created by Raj Kumar Sharma on 17/06/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

import UIKit

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var location: CLLocation?
    var authorizationStatus = CLAuthorizationStatus.notDetermined
    var updateInterval: Double = 60
    var initialized = false
    var running = false
    
    var timer: Timer?
    
    /// Callback for receiving location updates
    var locationUpdate: ((CLLocation?) -> Void)?
    
    /// Callback for receiving shanges to authorization status
    var authorizationUpdate: ((CLAuthorizationStatus) -> Void)?
    
    enum UpdateType {
        case whenInUse, always
    }
    
    var updateType = UpdateType.whenInUse
    
    /// Did user explicitly deny access to location services?
    var authorizationDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    func setup() {
        if initialized {
            return
        }
        initialized = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        switch updateType {
            
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
            break

        case .always:
            locationManager.requestAlwaysAuthorization()
            break
        }
    }
    
    func start() {
        setup()
        if !running {
            locationManager.startUpdatingLocation()
            running = true
        }
    }
    
    func stop() {
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
        running = false
        locationUpdate?(nil)
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locationManager.location
        
        //  Notify update callback
        locationUpdate?(location)
        
        //  Stop refresh and wait for updateInterval before checking location again
        locationManager.stopUpdatingLocation()
        running = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: self.updateInterval, target: self, selector: #selector(LocationService.start), userInfo: nil, repeats: false)
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        logInfo("Authorization Status: \(status.rawValue)")
        authorizationStatus = status
        authorizationUpdate?(status)
    }
    
    @objc func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logInfo("Error while updating location: \(error.localizedDescription)")
    }
}
