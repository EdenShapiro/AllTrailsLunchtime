//
//  LocationTracker.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 6/30/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import Foundation
import CoreLocation

class LocationTracker: NSObject {
    static let didChangeLocationNotification = Notification.Name("didChangeLocationNotification")
    static let shared = LocationTracker()
    private let manager: CLLocationManager = CLLocationManager()
    
    private override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.distanceFilter = 1000.0
        manager.startUpdatingLocation()
    }
    
    private(set) var location: CLLocation? { didSet {
        NotificationCenter.default.post(name: LocationTracker.didChangeLocationNotification, object: self)
    }}
}

extension LocationTracker: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            NSLog("location update is authorized")
            manager.requestLocation()
        } else if status == .notDetermined || status == .denied {
            NSLog("requestion location permission")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("location fetch failed \(error.localizedDescription)")
    }
    
}
