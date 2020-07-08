//
//  UIImageView+Extension.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/8/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.graySubtitleText
        return activityIndicator
    }
    
    private func startActivity(for indicator: UIActivityIndicatorView) {
        indicator.center = self.center
        addSubview(indicator)
        indicator.startAnimating()
    }
    
    private func stopActivity(for indicator: UIActivityIndicatorView)  {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
    
    func loadPhoto(for ref: String?) {
        guard let ref = ref else {
            self.image = UIImage(named: "meal")
            self.tintColor = UIColor.graySubtitleText
            return
        }
        
        let activityIndicator = createActivityIndicator()
        startActivity(for: activityIndicator)
        
        let cache = ImageCache.shared
        if let image = cache[ref] {
            self.image = image
            stopActivity(for: activityIndicator)
        } else {
            GooglePlacesClient.shared.getPhotoForReference(photoReference: ref) { (image, photoReference, error) in
                assertMainThread("Loading images off of main thread")
                self.stopActivity(for: activityIndicator)
                if let image = image, photoReference == ref  {
                    self.image = image
                    cache[ref] = image
                } else {
                    self.image = UIImage(named: "meal")
                    self.tintColor = UIColor.graySubtitleText
                }
            }
        }
    }
}
