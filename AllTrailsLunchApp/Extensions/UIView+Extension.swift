//
//  UIView+Extension.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/2/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0, height: newValue)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let shadowColor = layer.shadowColor {
                return UIColor(cgColor: shadowColor)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    func addShadow(radius: CGFloat = 10, color: UIColor = .gray) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: radius)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = radius
//        layer.name = "shadow"
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let cgcolor = layer.borderColor {
                return UIColor(cgColor: cgcolor)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

}
