//
//  MainViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 24/10/22.
//
import UIKit
import MapboxMaps

class MainViewController: UIViewController {
    internal var mapView: MapView!
    internal var cameraLocationConsumer: CameraLocationConsumer!
    internal var pointAnnotationManager: PointAnnotationManager!
    internal var targetCoordinate: CLLocationCoordinate2D!
    internal var animalData: Dictionary<String, JSONValue>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupUserLocation()
        // Do any additional setup after loading the view.
    }
    
    func setupMapView() {
        let options = MapInitOptions(cameraOptions: CameraOptions(center: centerCoordinate, zoom: 16), styleURI: StyleURI(rawValue: activeStyleURI))
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.location.delegate = self
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapClick)))
        view.addSubview(mapView)
    }
    
    func setupUserLocation() {
        cameraLocationConsumer = CameraLocationConsumer(mapView: mapView)
        mapView.location.options.puckType = .puck2D()

        mapView.mapboxMap.onNext(event: .mapLoaded) { _ in
            // Register the location consumer with the map
            // Note that the location manager holds weak references to consumers, which should be retained
            self.mapView.location.addLocationConsumer(newConsumer: self.cameraLocationConsumer)

//            self.finish() // Needed for internal testing purposes.
        }
    }
    
    @objc private func onMapClick(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let screenPoint = sender.location(in: mapView)
        let queryOptions = RenderedQueryOptions(layerIds: layerStyleIds, filter: nil)
        mapView.mapboxMap.queryRenderedFeatures(with: screenPoint, options: queryOptions, completion: { [weak self] result in
            switch result {
            case .success(let features):
                if let feature = features.first?.feature {
                    let dict = feature.properties!.reduce(into: [:]) { $0[$1.0] = $1.1 }
                    self!.animalData = dict
                    if let geometry = feature.geometry, case let Geometry.point(point) = geometry {
                        self!.targetCoordinate = point.coordinates
                        var customPointAnnotation = PointAnnotation(coordinate: self!.targetCoordinate)
                        if (self!.pointAnnotationManager != nil) {
                            self!.pointAnnotationManager.annotations = []
                        }
                        self!.pointAnnotationManager = self!.mapView.annotations.makePointAnnotationManager()
                        let uuid = NSUUID().uuidString
                        customPointAnnotation.image = .init(image: UIImage(named: "\(dict["clusterName"]!.rawValue) Active")!, name: "\(dict["clusterName"]!.rawValue) Active-\(uuid)")
                        self!.pointAnnotationManager.annotations = [customPointAnnotation]
                        
                        self!.removeSubview()
                        self!.showOverview()
                        self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: inactiveStyleURI)
                    }
                } else {
                    if (self!.pointAnnotationManager != nil) {
                        self!.pointAnnotationManager.annotations = []
                        self!.removeSubview()
                        self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: activeStyleURI)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func showOverview() {
//        print(targetCoordinate)
        
        lazy var overviewCardView: OverviewCardView = {
            let oVview = OverviewCardView()
            oVview.translatesAutoresizingMaskIntoConstraints = false
            oVview.tag = 1
            let type = animalData["type"]!.rawValue as? String
            let idName = animalData["idName"]!.rawValue as? String
            let clusterName = animalData["clusterName"]!.rawValue as? String
            oVview.title = idName
            oVview.targetCoordinate = targetCoordinate
            
            let imageView = UIImageView(image: UIImage(named: (type == "Kandang" ? idName : clusterName)!))
            imageView.frame = .zero
            imageView.translatesAutoresizingMaskIntoConstraints = false
            oVview.addSubview(imageView)
            
            imageView.anchor(
                bottom: oVview.bottomAnchor,
                left: oVview.rightAnchor,
                paddingBottom: -(type == "Kandang" ? 54 : 10),
                paddingLeft: -(view.bounds.height * ((type == "Kandang" ? 132 : 85) / 844)),
                width: view.bounds.height * ((type == "Kandang" ? 260 : 180) / 844),
                height: view.bounds.height * ((type == "Kandang" ? 260 : 180) / 844)
            )
            
            return oVview
        }()
        
        overviewCardView.overviewButton.addTarget(self, action: #selector(onOverviewClick), for: .touchUpInside)
        
        view.addSubview(overviewCardView)
        let safeArea = view.layoutMarginsGuide
        
        overviewCardView.anchor(
            bottom: safeArea.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingBottom: 20,
            paddingLeft: 16,
            paddingRight: 84,
            height: view.bounds.height * (132 / 844)
        )
    }
    
    func removeSubview(){
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    @objc private func onOverviewClick(_ sender: UIButton) {
        let animalDetailViewController = AnimalDetailViewController()
        animalDetailViewController.modalPresentationStyle = .fullScreen
        animalDetailViewController.animalData = animalData
        animalDetailViewController.targetCoordinate = targetCoordinate
        self.present(animalDetailViewController, animated: true, completion: nil)
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

extension MainViewController: LocationPermissionsDelegate {
    func locationManager(_ locationManager: LocationManager, didChangeAccuracyAuthorization accuracyAuthorization: CLAccuracyAuthorization) {
        if accuracyAuthorization == .reducedAccuracy {
            // Perform an action in response to the new change in accuracy
        }
    }
}


import SwiftUI

struct MainViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UIMainViewControllerPreview {
            return MainViewController()
        }
        .previewDevice("iPhone 13")
    }
}

@available(iOS 13, *)
struct UIMainViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    func makeUIViewController(context: Context) -> ViewController { viewController }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
    
    
}
