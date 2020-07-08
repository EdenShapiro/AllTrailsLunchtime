//
//  APIKeys.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/2/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import Foundation

struct APIKeys {
    static func keyForAPI(named keyname: String) -> String? {
        if let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: filePath),
            let value = plist.object(forKey: keyname) as? String {
                return value
        }
        return nil
    }
}


