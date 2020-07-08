//
//  PlaceMarker.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/5/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: Place
    
    init(place: Place, selected: Bool) {
        self.place = place
        super.init()
        
        if let location = place.geometry?.location {
            position = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            assertionFailure("No location")
        }
        icon = selected ? UIImage(named: "active-map-pin") : UIImage(named: "static-map-pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
