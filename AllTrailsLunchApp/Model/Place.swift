//
//  Place.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 6/30/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import Foundation

struct Place: Codable {
    
    let formattedAddress: String?
    let geometry: Geometry?
    let rating: Double?
    let name: String?
    let openingHours: OpeningHours?
    let placeId: String?
    let photos: [Photo]?
    let priceLevel: PriceLevel?
    let userRatingsTotal: Int?
    
    struct OpeningHours: Codable {
        let openNow: Bool?
    }

    struct Photo: Codable {
        let photoReference: String?
    }

    enum PriceLevel: Int, Codable {
        case free, oneDollar, twoDollars, threeDollars, fourDollars
    }
    
    struct Geometry: Codable {
        var location: Location
        struct Location: Codable {
            let latitude: Double
            let longitude: Double
            
            enum CodingKeys: String, CodingKey {
                case latitude = "lat"
                case longitude = "lng"
            }
        }
    }
}
struct SearchResponse: Codable {
    let results: [Place]?
    let nextPageToken: String?
}

