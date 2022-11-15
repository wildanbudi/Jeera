//
//  Navigation.swift
//  Jeera
//
//  Created by Wildan Budi on 03/11/22.
//

import Foundation
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import CoreLocation

extension AnimalDetailViewController {
    @objc func startNavigation() {
        timer.invalidate()
        let origin = Waypoint(coordinate: userLocation, name: "Mapbox")
        let destination = Waypoint(coordinate: targetCoordinate, name: detailData["idName"]!.rawValue as? String)
        
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
                
                bottomBanner.animalDetailViewController = self
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

//extension AnimalDetailViewController: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("masuk")
//        if ((manager.location?.coordinate) != nil) {
//            mapView.location.options.puckType = .puck2D()
//            userLocation = manager.location?.coordinate
//        }
//    }
//}
