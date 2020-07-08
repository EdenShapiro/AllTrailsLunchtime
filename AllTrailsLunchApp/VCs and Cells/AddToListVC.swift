//
//  AddToListVC.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/8/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit
import PanModal

class AddToListVC: UIViewController, PanModalPresentable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var showDragIndicator: Bool {
        return false
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(170)
    }

    var longFormHeight: PanModalHeight {
        return shortFormHeight
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}


