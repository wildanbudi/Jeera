//
//  NavigateViewController.swift
//  Jeera
//
//  Created by Wildan Budi on 21/10/22.
//

import UIKit
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import CoreLocation

class NavigateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Define two waypoints to travel between
        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: -6.307248, longitude: 106.82037), name: "Mapbox")
        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: -6.308459, longitude: 106.822004), name: "Kandang Ayam")

        // Set options
        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination])

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
                let bottomBanner = BottomBannerViewController()
                let navigationService = MapboxNavigationService(routeResponse: response,
                                                                routeIndex: 0,
                                                                routeOptions: routeOptions,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials)
                let navigationOptions = NavigationOptions(styles: [CustomDayStyle()], navigationService: navigationService, bottomBanner: bottomBanner)
                let navigationViewController = NavigationViewController(for: response,
                                                                           routeIndex: 0,
                                                                           routeOptions: routeOptions,
                                                                           navigationOptions: navigationOptions)
//                        bottomBanner.navigationViewController = navigationViewController
                         
                        let parentSafeArea = navigationViewController.view.safeAreaLayoutGuide
                        let bannerHeight: CGFloat = 150.0
//                        let verticalOffset: CGFloat = 0.0
//                        let horizontalOffset: CGFloat = 0.0
                         
                        // To change top and bottom banner size and position change layout constraints directly.
//                        topBanner.view.topAnchor.constraint(equalTo: parentSafeArea.topAnchor).isActive = true
                         
                        bottomBanner.view.heightAnchor.constraint(equalToConstant: bannerHeight).isActive = true
                        bottomBanner.view.anchor(
                            bottom: parentSafeArea.bottomAnchor,
                            left: parentSafeArea.leftAnchor,
                            right: parentSafeArea.rightAnchor,
                            paddingBottom: 0,
                            paddingLeft: 0,
                            paddingRight: 0)
                         
                        navigationViewController.modalPresentationStyle = .fullScreen
                         
                        strongSelf.present(navigationViewController, animated: true, completion: nil)
//                        navigationViewController.floatingButtons = []
                        navigationViewController.showsSpeedLimits = false
                        bottomBanner.modalPresentationStyle = .popover
                navigationViewController.routeLineTracksTraversal = true
//
//                strongSelf.present(navigationViewController, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct NaviagteViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UINavigateViewControllerPreview {
            return NavigateViewController()
        }
        .previewDevice("iPhone 12")
    }
}

import SwiftUI

@available(iOS 13, *)
struct UINavigateViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    func makeUIViewController(context: Context) -> ViewController { viewController }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
    
    
}
