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
                let navigationService = MapboxNavigationService(routeResponse: response,
                                                                routeIndex: 0,
                                                                routeOptions: routeOptions,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials)
                let navigationOptions = NavigationOptions(styles: [CustomDayStyle(), CustomNightStyle()],
                                                          navigationService: navigationService)
                let navigationViewController = NavigationViewController(for: response,
                                                                           routeIndex: 0,
                                                                           routeOptions: routeOptions,
                                                                           navigationOptions: navigationOptions)
                navigationViewController.modalPresentationStyle = .fullScreen
                // Render part of the route that has been traversed with full transparency, to give the illusion of a disappearing route.
                navigationViewController.routeLineTracksTraversal = true

                strongSelf.present(navigationViewController, animated: true, completion: nil)
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
