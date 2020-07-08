//
//  PlaceCell.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 7/8/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit

protocol PlaceCellDelegate: class {
     func showListVC()
}

class PlaceCell: UITableViewCell {
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var ratingsStackView: UIStackView!
    @IBOutlet var numberOfRatingsLabel: UILabel!
    @IBOutlet var costAndInfoLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    weak var delegate: PlaceCellDelegate!
    
    var place: Place! { didSet {
        placeImageView.loadPhoto(for: place.photos?.first?.photoReference)
        placeNameLabel.text = place.name
        numberOfRatingsLabel.text = place.userRatingsTotal != nil ? "(\(place.userRatingsTotal!))" : nil
        
        var costAndInfoText = ""
        if let priceLevel = place.priceLevel {
            for _ in 0..<priceLevel.rawValue {
                costAndInfoText += "$"
            }
        }
        
        var openOrClosedText = ""
        if let openNow = place.openingHours?.openNow {
            openOrClosedText = openNow ? "Open" : "Closed"
        }
        
        if costAndInfoText.isEmpty || openOrClosedText.isEmpty {
            costAndInfoLabel.text = "\(costAndInfoText)\(openOrClosedText)"
        } else {
            costAndInfoLabel.text = "\(costAndInfoText) • \(openOrClosedText)"
        }
        
        if let rating = place.rating {
            for index in 0..<Int(rating.rounded()) {
                ratingsStackView.arrangedSubviews[index].tintColor = UIColor.starYellow
            }
        }
        layoutIfNeeded()
        }}
    
    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = nil
        placeNameLabel.text = nil
        costAndInfoLabel.text = nil
        numberOfRatingsLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
    }
    
    @IBAction func heartButtonTapped(_ sender: Any) {
        delegate.showListVC()
    }
}
