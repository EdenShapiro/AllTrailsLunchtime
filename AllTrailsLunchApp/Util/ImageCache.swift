//
//  ImageCache.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/7/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit

class ImageCache {

    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    

    subscript(key: String) -> UIImage? {
        get {
            return cache.object(forKey: key as NSString)
        }

        set (newValue) {
            guard let newValue = newValue else {
                cache.removeObject(forKey: key as NSString)
                return
            }
            cache.setObject(newValue, forKey: key as NSString)
        }
    }
}
