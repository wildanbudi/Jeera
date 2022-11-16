//
//  MainViewControllerExtension.swift
//  Jeera
//
//  Created by Anggi Dastariana on 08/11/22.
//

import Foundation
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import CoreLocation

extension MainViewController {
    func startNavigation() {
        let origin = Waypoint(coordinate: userLocation!, name: "Mapbox")
        let destination = Waypoint(coordinate: targetCoordinate, name: annotationData["idName"]!.rawValue as? String)
        
        // Set options
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: ProfileIdentifier(rawValue: "mapbox/walking"))
        routeOptions.locale = Locale(identifier: "id")
        
        // Request a route using MapboxDirections.swift
        Directions.shared.calculate(routeOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                // Pass the first generated route to the the NavigationViewController
                let topBanner = TopBannerViewController()
                let bottomBanner = BottomBannerViewController()
                let navigationService = MapboxNavigationService(
                    routeResponse: response,
                    routeIndex: 0,
                    routeOptions: routeOptions,
                    customRoutingProvider: NavigationSettings.shared.directions,
                    credentials: NavigationSettings.shared.directions.credentials)
                let navigationOptions = NavigationOptions(styles: [CustomDayStyle()], navigationService: navigationService, topBanner: topBanner, bottomBanner: bottomBanner)
                let navigationViewController = NavigationViewController(for: response,
                                                                        routeIndex: 0,
                                                                        routeOptions: routeOptions,
                                                                        navigationOptions: navigationOptions)
                
                bottomBanner.mainViewController = self
                bottomBanner.navigationViewController = navigationViewController
                
                let parentSafeArea = navigationViewController.view.safeAreaLayoutGuide
                let bannerHeight: CGFloat = 200.0
                
                // To change top and bottom banner size and position change layout constraints directly.
                topBanner.view.topAnchor.constraint(equalTo: parentSafeArea.topAnchor).isActive = true
//                bottomBanner.view.topAnchor.constraint(equalTo: parentSafeArea.topAnchor).isActive = true
                
                bottomBanner.view.heightAnchor.constraint(equalToConstant: bannerHeight).isActive = true
                
                navigationViewController.modalPresentationStyle = .fullScreen
                
                strongSelf.present(navigationViewController, animated: true, completion: nil)
                navigationViewController.floatingButtons = []
                navigationViewController.showsSpeedLimits = false
                                bottomBanner.modalPresentationStyle = .popover
                navigationViewController.routeLineTracksTraversal = true
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate Extension
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ((manager.location?.coordinate) != nil) {
            setupUserLocation()
            userLocation = manager.location!.coordinate
            if AnimalDetailViewController.isOnJourneyClick {
                animalDetailViewController.userLocation = manager.location!.coordinate
                view.addSubview(centerLocationButton)
                centerLocationButton.anchor(
                    top: searchButton.bottomAnchor,
                    right: view.rightAnchor,
                    paddingTop: 10,
                    paddingRight: 16,
                    width: view.bounds.height * (45 / 844),
                    height: view.bounds.height * (45 / 844)
                )
            }
            if isButtonLocationOffClick {
                view.addSubview(centerLocationButton)
                centerLocationButton.anchor(
                    top: searchButton.bottomAnchor,
                    right: view.rightAnchor,
                    paddingTop: 10,
                    paddingRight: 16,
                    width: view.bounds.height * (45 / 844),
                    height: view.bounds.height * (45 / 844)
                )
            }
            if isOnJourneyClick {
                startNavigation()
            }
        }
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    buttonLocationOFF.removeFromSuperview()
                }
            }
        } else if status == .denied || status == .restricted || status == .notDetermined{
            view.addSubview(buttonLocationOFF)
        } else if status == .authorizedWhenInUse {
            buttonLocationOFF.removeFromSuperview()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if userLocation != locations[0].coordinate {
            userLocation = locations[0].coordinate
        }
    }
}
