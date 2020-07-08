//
//  UINavigationController+Extension.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/3/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func hideBottomHairline() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.shadowColor = UIColor.clear
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.backgroundColor = .white
        self.standardAppearance = navBarAppearance
        self.scrollEdgeAppearance = navBarAppearance
    }
}

