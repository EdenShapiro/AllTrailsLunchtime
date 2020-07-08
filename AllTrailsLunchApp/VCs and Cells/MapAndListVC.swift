//
//  MapAndListVC.swift
//  AllTrailsLunchApp
//
//  Created by Eden Shapiro on 6/30/20.
//  Copyright © 2020 Eden Shapiro. All rights reserved.
//

import UIKit
import GoogleMaps
import PanModal

class MapAndListVC: UIViewController {
    @IBOutlet var navBarSupportingView: UIView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var tableViewBottomConstraint: NSLayoutConstraint!

    var tableViewShowing: Bool {
        return !tableView.isHidden
    }
    var places: [Place] = [Place]() { didSet {
        mapView.clear()
        places.forEach {
            let marker = PlaceMarker(place: $0, selected: false)
            marker.map = self.mapView
        }
        tableView.reloadData()
        }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotifications()
        setupSearchBar()
        setupTableView()
        setupGoogleMap()
        setupLocationTracker()
        setupNavBar()
        hideTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSearchBar()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: LocationTracker.didChangeLocationNotification, object: nil)
    }
    
    private func setupLocationTracker() {
        _ = LocationTracker.shared
    }
    
    private func hideTableView() {
        tableViewBottomConstraint.constant = -UIScreen.main.bounds.height
        mapButton.setTitle("List", for: .normal)
        mapButton.setImage(UIImage(named: "list-icon")!, for: .normal)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (done) in
            self.tableView.isHidden = true
        }
        
    }
    
    private func showTableView() {
        tableViewBottomConstraint.constant = 0
        mapButton.setTitle("Map", for: .normal)
        mapButton.setImage(UIImage(named: "pin-symbol")!, for: .normal)
        tableView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { (done) in
            self.tableView.isHidden = false
        }
    }
    
    private func setupNavBar() {
        guard let navBar =  navigationController?.navigationBar else {
            assertionFailure("Missing navbar")
            return
        }
        navBar.hideBottomHairline()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.searchBarStyle = .prominent
        searchBar.borderColor = UIColor.white
        searchBar.barTintColor = .white
        searchBar.tintColor = .white
        searchBar.backgroundColor = .white
        searchBar.backgroundImage = UIImage()
        
        let searchTextField = searchBar.searchTextField
        searchTextField.backgroundColor = .white
        searchTextField.layer.borderColor = UIColor.emptyGray.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = 6
        searchBar.setImage(UIImage(named: "magnifying-glass"), for: .search, state: .normal)

        UITextField.appearance(whenContainedInInstancesOf: [type(of: searchBar)]).tintColor = UIColor.ATGreen
        let attributedPlaceholder = NSAttributedString(string: NSLocalizedString(" Find a restaurant", comment: ""),
                                                       attributes: [.foregroundColor: UIColor.graySubtitleText,
                                                                    .font: UIFont.proximaNova15])
        searchTextField.font = UIFont.proximaNova15
        searchTextField.attributedPlaceholder = attributedPlaceholder
        
    // TODO: Move the magnifying glass to the right-hand side:
    //        let imageView = UIImageView(image: UIImage(named: "magnifying-glass"))
    //        searchTextField.leftView = nil
    //        searchTextField.leftViewMode = .never
    //        searchTextField.rightView = imageView
    //        searchTextField.rightViewMode = .always
    //        searchTextField.layoutIfNeeded()

    }
    
    
    private func setupGoogleMap() {
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    @objc private func locationChanged() {
        NSLog("Location updated notification received")
        findNearbyRestaurants()
    }
    
    private func findNearbyRestaurants(with searchText: String? = nil) {
        guard let location = LocationTracker.shared.location else {
            assertionFailure("Location not found")
            return
        }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let text = searchText?.isEmpty != false ? nil : searchText
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        mapView!.camera = camera
        mapView!.animate(to: camera)
        GooglePlacesClient.shared.findRestaurants(with: text, longitude: location.coordinate.longitude, latitude: location.coordinate.latitude) { (places, error) in
            if let error = error {
                NSLog("Error in findNearbyRestaurants: \(error.localizedDescription)")
                return
            }
            
            guard let places = places, places.count > 0 else {
                // TODO: show no nearby places error
                NSLog("No nearby places!")
                return
            }
            
            self.places = places
        }
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        searchBar.endEditing(true)
    }
    
    @IBAction func mapButtonTapped(_ sender: Any) {
        if tableViewShowing {
            hideTableView()
        } else {
            showTableView()
        }
    }
}


extension MapAndListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as! PlaceCell
        cell.delegate = self
        cell.place = places[indexPath.row]
        return cell
    }
    
}

extension MapAndListVC: UISearchBarDelegate {
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResults()
        searchBar.endEditing(true)
    }
    
    func updateSearchResults() {
        findNearbyRestaurants(with: searchBar.text)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == true {
            findNearbyRestaurants()
        }
    }
    
}

extension MapAndListVC: PlaceCellDelegate {
    func showListVC() {
        searchBar.endEditing(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddToListVC") as! AddToListVC
        presentPanModal(controller)
    }
}

// MARK: - GMSMapViewDelegate
extension MapAndListVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        if let selectedMarker = mapView.selectedMarker {
            selectedMarker.icon = UIImage(named: "static-map-pin")
        }
        
        mapView.selectedMarker = marker
        marker.icon = UIImage(named: "active-map-pin")
        return true
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }

        guard let placeInfoCell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as? PlaceCell else {
            return nil
        }
        placeInfoCell.delegate = self
        placeInfoCell.place = placeMarker.place

        guard let placeInfoView = placeInfoCell.contentView.subviews.first!.subviews.first(where: { $0.tag == 66 }) else {
            return nil
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height:  110))
        imageView.image = UIImage(named: "map-bubble")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        placeInfoView.translatesAutoresizingMaskIntoConstraints = true
        imageView.addSubview(placeInfoView)

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: placeInfoView, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .top, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: placeInfoView, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: placeInfoView, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: placeInfoView, attribute: .trailing, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 96),
            NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        ])
        
        imageView.layoutIfNeeded()
        return imageView
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        
    }
}

extension MapAndListVC: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (tableView.contentOffset.y < 0 && velocity.y < -2) || tableView.contentOffset.y < -200 {
            hideTableView()
        }
    }
}
