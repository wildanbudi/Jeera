//
//  AnimalDetailViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 27/10/22.
//

import UIKit
import MapboxMaps
import MapboxDirections

class AnimalDetailViewController: UIViewController {
    var mapView: MapView!
    var detailData: Dictionary<String, JSONValue>!
    var targetCoordinate: CLLocationCoordinate2D!
    var userLocation: CLLocationCoordinate2D!
    var distance: Int!
    var travelTime: Int!
    var type: String!
    var name: String!
    var animalsData: [AllData]!
    var animalsList: [AllData]!
    private (set) static var isOnJourneyClick = false
    var timer = Timer()
    
    lazy var backButton: UIButton = {
        let button = BackButton()
        button.addTarget(self, action: #selector(self.backButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var animalImage: UIImageView = {
        let imageName = detailData[(type == "Kandang" || type == "Hewan" ? "idName" : "clusterName")]!.rawValue as? String
        let imageView = UIImageView(image: UIImage(named: imageName!))
        
        return imageView
    }()
    
    lazy var detailNameLabel: UILabel = {
        let label = DetailLabel()
        label.text = name
        
        return label
    }()
    
    lazy var distanceLabel = labelWithIcon(imageName: "Distance", labelText: "\(distance ?? 0) meter", iconColor: .PrimaryGreen)
    
    lazy var etaLabel = labelWithIcon(imageName: "Time", labelText: "\(travelTime ?? 0) menit", iconColor: .PrimaryGreen)
    
    lazy var cageLabel = labelWithIcon(imageName: "Location", labelText: (detailData["cage"]!.rawValue as? String)!, iconColor: .PrimaryGreen)
    
    lazy var informationView: UIStackView = {
        let stackView = DetailStackView(spacing: 20.0)
        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(etaLabel)
        if type == "Hewan" {
            let idName = name
            let cage = detailData["cage"]!.rawValue as? String
            if idName != cage {
                stackView.addArrangedSubview(cageLabel)
            }
        }
        
        return stackView
    }()
    
    lazy var animalListButton: UIButton = {
        let button = OutlinedButton(title: "Lihat Daftar Hewan", textWeight: .regular)
        button.addTarget(self, action: #selector(animalsListClick), for: .touchUpInside)
        
        return button
    }()
    
    lazy var startJourneyButton: UIButton = {
        let button = StartJourneyButton()
        button.addTarget(self, action: #selector(onJourneyClick), for: .touchUpInside)
        
        return button
    }()
    
    lazy var buttonsStack: UIStackView = {
        let stackView = DetailStackView(spacing: 15.0)
        stackView.addArrangedSubview(animalListButton)
        stackView.addArrangedSubview(startJourneyButton)
        
        return stackView
    }()
    
    lazy var overviewMapView: MapView = {
        let mapInstance = Map()
        mapInstance.zoomLevel = 16.5
        mapInstance.targetCoordinate = targetCoordinate
        let mapView = mapInstance.getMapView()
        
        let clusterName = detailData["clusterName"]!.rawValue as? String
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        var customPointAnnotation = PointAnnotation(coordinate: targetCoordinate)
        customPointAnnotation.image = .init(image: UIImage(named: "\(clusterName!) Active")!, name: "\(clusterName!) Active")
        pointAnnotationManager.annotations = [customPointAnnotation]
        
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (userLocation != nil) && (distance == nil || distance == 0) {
            getRouteInformation()
        } else {
            setupView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer.invalidate()
    }
    
    @objc func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onJourneyClick(_ sender: UIButton) {
        AnimalDetailViewController.isOnJourneyClick = true
        let alertController = UIAlertController(title: "Izinkan Jeera untuk mengakses lokasi kamu?", message: "Nyalakan lokasimu untuk mendapat petunjuk jalan", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        let locationManager = CLLocationManager()
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            startNavigation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startNavigation), userInfo: nil, repeats: true)
        case .restricted, .denied:
            self.present(alertController, animated: true, completion: nil)
        default :
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    }

    @objc func animalsListClick(_ sender: UIButton) {
        let animalsListViewController = AnimalsListViewController()
        animalsListViewController.modalPresentationStyle = .formSheet
        animalsListViewController.animalsData = self.animalsList
        self.present(animalsListViewController, animated: true, completion: nil)
    }
    
    func setupView() {
        type = detailData["type"]!.rawValue as? String
        name = detailData["idName"]!.rawValue as? String
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.UpperGradient.cgColor, UIColor.LowerGradient.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        if cagesMultipleAnimals.contains(name) && detailData["type"] == "Kandang" {
            if userLocation == nil {
                [backButton, animalImage, detailNameLabel, overviewMapView, buttonsStack].forEach {
                    view.addSubview($0)
                }
            } else {
                [backButton, animalImage, detailNameLabel, overviewMapView, informationView, buttonsStack].forEach {
                    view.addSubview($0)
                }
            }
        } else {
            if userLocation == nil {
                [backButton, animalImage, detailNameLabel, overviewMapView, startJourneyButton].forEach {
                    view.addSubview($0)
                }
            } else {
                [backButton, animalImage, detailNameLabel, overviewMapView, informationView, startJourneyButton].forEach {
                    view.addSubview($0)
                }
            }
        }
        setupConstraint()
        filterAnimalsList()
    }
    
    func setupConstraint() {
        let safeArea = view.layoutMarginsGuide
        
        backButton.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            paddingTop: 47,
            paddingLeft: 16,
            width: view.bounds.height * (30 / 844),
            height: view.bounds.height * (30 / 844)
        )
        
        animalImage.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: view.bounds.height * (390 / 844)
        )
        
        if cagesMultipleAnimals.contains(name) && detailData["type"] == "Kandang" {
            buttonsStack.anchor(
                bottom: safeArea.bottomAnchor,
                left: view.leftAnchor,
                paddingBottom: 14,
                paddingLeft: 16,
                height: view.bounds.height * (50 / 844)
            )
            buttonsStack.centerX(inView: view)
        } else {
            startJourneyButton.anchor(
                bottom: safeArea.bottomAnchor,
                left: view.leftAnchor,
                paddingBottom: 14,
                paddingLeft: 16,
                height: view.bounds.height * (50 / 844)
            )
            startJourneyButton.centerX(inView: view)
        }
        
        overviewMapView.anchor(
            bottom: startJourneyButton.topAnchor,
            left: view.leftAnchor,
            paddingBottom: 20,
            paddingLeft: 16,
            height: view.bounds.height * (214 / 844)
        )
        
        overviewMapView.centerX(inView: view)
        
        if userLocation == nil {
            detailNameLabel.anchor(
                bottom: overviewMapView.topAnchor,
                left: view.leftAnchor,
                paddingBottom: 5,
                paddingLeft: 16,
                width: view.bounds.height * (332 / 844),
                height: view.bounds.height * (48 / 844)
            )
        } else {
            informationView.anchor(
                bottom: overviewMapView.topAnchor,
                left: view.leftAnchor,
                paddingBottom: 20,
                paddingLeft: 16
            )
            
            detailNameLabel.anchor(
                bottom: informationView.topAnchor,
                left: view.leftAnchor,
                paddingBottom: 5,
                paddingLeft: 16,
                width: view.bounds.height * (332 / 844),
                height: view.bounds.height * (48 / 844)
            )
        }
    }
    
    func getRouteInformation() {
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: userLocation, name: "origin"),
            Waypoint(coordinate: targetCoordinate, name: "destination"),
        ]
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)
        let _ = directions.calculate(options) { (session, result) in
            switch result {
            case .failure(let error):
                print("Error calculating directions: \(error)")
            case .success(let response):
                guard let route = response.routes?.first, let _ = route.legs.first else {
                    return
                }
                
                self.distance = Int(route.distance)
                self.travelTime = Int(route.expectedTravelTime/60) + 1
                
                self.setupView()
            }
        }
    }
    
    func filterAnimalsList() {
        if cagesMultipleAnimals.contains(name) && detailData["type"] == "Kandang" {
            animalsList = animalsData.filter({ (animal: AllData) -> Bool in
                return animal.cage == name
            })
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


import SwiftUI

struct AnimalDetailViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UIAnimalDetailViewControllerPreview {
            return AnimalDetailViewController()
        }
        .previewDevice("iPhone 13")
    }
}

@available(iOS 13, *)
struct UIAnimalDetailViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    func makeUIViewController(context: Context) -> ViewController { viewController }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
    
    
}
