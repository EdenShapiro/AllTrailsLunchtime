//
//  GoogleMapsClient.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/2/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import Foundation
import GoogleMaps

class GoogleMapsClient {
    static var shared = GoogleMapsClient()
    
    init() {
        if let apiKey = APIKeys.keyForAPI(named: "googleMapsKey") {
            GMSServices.provideAPIKey(apiKey)
        } else {
            assertionFailure("Google Maps API key not found")
        }
    }
}
