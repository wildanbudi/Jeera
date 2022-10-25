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
                    let markerCoordinates: CLLocationCoordinate2D
                    if let geometry = feature.geometry, case let Geometry.point(point) = geometry {
                        markerCoordinates = point.coordinates
                        var customPointAnnotation = PointAnnotation(coordinate: markerCoordinates)
                        let pointAnnotationManager = self!.mapView.annotations.makePointAnnotationManager()
                        
                        customPointAnnotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
                        
                        pointAnnotationManager.annotations = [customPointAnnotation]
                        
                    }
                    
                    let dict = feature.properties!.reduce(into: [:]) { $0[$1.0] = $1.1 }
                    self!.showAnimalPreview(dict: dict)
                    self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: inactiveStyleURI)
                } else {
                    self?.removeSubview()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func showAnimalPreview(dict: Dictionary<String, JSONValue>) {
        print(dict)
        let animalPreviewCardView = AnimalPreviewCardView(frame: CGRect(x: (view.frame.width/2) - 145, y: view.frame.height - 180, width: 290, height: 132))
        animalPreviewCardView.tag = 1
        animalPreviewCardView.title = dict["idName"]!.rawValue as? String
        animalPreviewCardView.layer.cornerRadius = 20
        
        let imageView = UIImageView(image: UIImage(named: "Assets (Overview Hewan)"))
        imageView.frame = CGRect(x: 140, y: -50, width: 250, height: 230)
        animalPreviewCardView.addSubview(imageView)
        
        view.addSubview(animalPreviewCardView)
    }
    
    func removeSubview(){
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
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

extension MainViewController: LocationPermissionsDelegate {
    func locationManager(_ locationManager: LocationManager, didChangeAccuracyAuthorization accuracyAuthorization: CLAccuracyAuthorization) {
        if accuracyAuthorization == .reducedAccuracy {
            // Perform an action in response to the new change in accuracy
        }
    }
}
