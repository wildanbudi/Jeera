//
//  MainViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 24/10/22.
//
import UIKit
import MapboxMaps
import MapboxDirections
import CoreLocation

class MainViewController: UIViewController {
    internal var mapView: MapView!
    internal var mapViewRetrieveData: MapView!
    internal var cameraLocationConsumer: CameraLocationConsumer!
    internal var pointAnnotationManager: PointAnnotationManager!
    internal var targetCoordinate: CLLocationCoordinate2D!
    internal var annotationData: Dictionary<String, JSONValue>!
    internal var userLocation: CLLocationCoordinate2D?
    internal var animalsData: [AllData] = []
    internal var facilitiesData: [AllData] = []
    internal var cagesData: [AllData] = []
    
    lazy var whiteBackground = UIView()
    lazy var segmentedBase = UIView()
    lazy var segmentedButtons = [UIButton]()
    lazy var segmentedSelector = UIView()
    lazy var selectedSegmentIndex = 0
    lazy var buttonLocationOFF = UIButton(type: .custom)
    lazy var searchButton = SearchButton()
    lazy var centerLocationButton: UIButton = {
        let button = CenterLocationButton()
        button.addTarget(self, action: #selector(centerLocation), for: .touchUpInside)
        
        return button
    }()
    lazy var outsideAreaAlert = UIAlertController.outsideArea()
    lazy var container = UIView()
    lazy var buttonRoute = UIButton(type: .custom)
    
    var timer = Timer()
    var isButtonLocationOffClick = false
    var isSearch = false
    var isOnJourneyClick = false
    var animalDetailViewController: AnimalDetailViewController!
    
    private(set) static var instance: MainViewController!
    private(set) static var isOutsideArea = false
    
    // Initiate The Core Location Manager
    let locationManager = CLLocationManager()
    
    // Set the iPhone Status Bar to Dark
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        segmentedBackground()
        locationOffButton()
        customSegmentedControl()
        setupSearchBtn()
        setupConstraint()
        popUpRute()
        routeButton()
        setupSplashScreen()
        MainViewController.instance = self
        
        // Check the User's Core Location Status Through the CLLocationDelegate Function
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.animalsData.count == 0 {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(retrieveAnnotationData), userInfo: nil, repeats: true)
        }
    }
    
    func setupMapView() {
        let mapRetrieveInstance = Map()
        mapRetrieveInstance.zoomLevel = 10
        mapViewRetrieveData = mapRetrieveInstance.getMapView()
        view.addSubview(mapViewRetrieveData)
        
        let mapInstance = Map()
        mapInstance.zoomLevel = 16
        mapView = mapInstance.getMapView()
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapClick)))
        view.addSubview(mapView)
    }
    
    func setupSplashScreen() {
        let splashScreen = UIImageView(image: UIImage(named: "Logo 1"))
        splashScreen.tag = 3
        splashScreen.frame = view.frame
        view.addSubview(splashScreen)
    }
    
    func setupLoadingScreen() {
        let loadingView = LoadingScreenUIView()
        loadingView.tag = 4
        loadingView.frame = view.frame
        view.addSubview(loadingView)
    }
    
    @objc func retrieveAnnotationData() {
        timer.invalidate()
        let layerIds = isSearch ? ["ragunanzoofacilities"] : layerStyleOverlapIds
        let queryOptions = RenderedQueryOptions(layerIds: layerIds, filter: nil)
        mapViewRetrieveData.mapboxMap.queryRenderedFeatures(with: mapView.safeAreaLayoutGuide.layoutFrame, options: queryOptions, completion: { [weak self] result in
            switch result {
            case .success(let queriedFeatures):
                if queriedFeatures.count > 0 {
                    self!.animalsData.removeAll()
                    self!.cagesData.removeAll()
                    self!.facilitiesData.removeAll()
                    for (i, data) in queriedFeatures.enumerated() {
                        let parsedFeature = data.feature.properties!.reduce(into: [:]) { $0[$1.0] = $1.1 }
                        let typeFeature = parsedFeature["type"]!.rawValue as! String
                        if let geometry = data.feature.geometry, case let Geometry.point(point) = geometry {
                            let coordinate = point.coordinates
                            let isLastIndex = i+1 == queriedFeatures.count
                            self!.mappingAnnotationData(locationCoordinate: coordinate, parsedFeature: parsedFeature, typeFeature: typeFeature, isLastIndex: isLastIndex)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func setupUserLocation() {
        cameraLocationConsumer = CameraLocationConsumer(mapView: mapView)
        let configuration = Puck2DConfiguration(topImage: UIImage(named: "Current location"))
        mapView.location.options.puckType = .puck2D(configuration)
        
        mapView.mapboxMap.onNext(event: .mapLoaded) { _ in
            // Register the location consumer with the map
            // Note that the location manager holds weak references to consumers, which should be retained
            self.mapView.location.addLocationConsumer(newConsumer: self.cameraLocationConsumer)
            //            self.finish() // Needed for internal testing purposes.
        }
    }
    
    func setupSearchBtn() {
        searchButton.addTarget(self, action: #selector(searchButtonClick(_:)), for: .touchUpInside)
        view.addSubview(searchButton)
    }
    
    @objc private func searchButtonClick(_ sender: UIButton) {
        if userLocation != nil {
            isSearch = true
            let facilities = facilitiesData
            facilitiesData.removeAll()
            for (i, data) in facilities.enumerated() {
                let dataCoordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.long)
                let isLastIndex = i+1 == facilities.count
                mappingAnnotationData(locationCoordinate: dataCoordinate, parsedFeature: data.dict, typeFeature: "Fasilitas", isLastIndex: isLastIndex)
            }
        } else {
            let searchViewController = SearchViewController()
            searchViewController.modalPresentationStyle = .formSheet
            searchViewController.animalsData = self.animalsData
            searchViewController.facilitiesData = self.facilitiesData
            searchViewController.userLocation = self.userLocation
            self.present(searchViewController, animated: true, completion: nil)
        }
    }
    
    func mappingAnnotationData(locationCoordinate: CLLocationCoordinate2D, parsedFeature: Dictionary<String, JSONValue>, typeFeature: String, isLastIndex: Bool) {
        if userLocation != nil {
            let directions = Directions.shared
            let waypoints = [
                Waypoint(coordinate: userLocation!, name: "origin"),
                Waypoint(coordinate: locationCoordinate, name: "destination"),
            ]
            let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)
            if self.isSearch {
                let _ = directions.calculate(options) { (session, result) in
                    switch result {
                    case .failure(let error):
                        print("Error calculating directions: \(error)")
                        return
                    case .success(let response):
                        guard let route = response.routes?.first, let _ = route.legs.first else {
                            return
                        }
                        self.appendAnnotationData(typeFeature: typeFeature, parsedFeature: parsedFeature, locationCoordinate: locationCoordinate, distance: route.distance, travelTime: (route.expectedTravelTime/60) + 1)
                        if isLastIndex {
                            let searchViewController = SearchViewController()
                            searchViewController.modalPresentationStyle = .formSheet
                            searchViewController.animalsData = self.animalsData
                            searchViewController.facilitiesData = self.facilitiesData
                            searchViewController.userLocation = self.userLocation
                            self.present(searchViewController, animated: true, completion: nil)
                            self.isSearch = false
                        }
                    }
                }
            } else {
                appendAnnotationData(typeFeature: typeFeature, parsedFeature: parsedFeature, locationCoordinate: locationCoordinate)
                if isLastIndex {
                    self.removeSubview(tag: 3)
                    getRouteInformation()
                }
            }
        } else {
            appendAnnotationData(typeFeature: typeFeature, parsedFeature: parsedFeature, locationCoordinate: locationCoordinate)
            if isLastIndex {
                self.removeSubview(tag: 3)
                NSLayoutConstraint.activate([
                    self.buttonRoute.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
                    self.buttonRoute.topAnchor.constraint(equalTo: self.searchButton.bottomAnchor, constant: 10),
                    self.buttonRoute.widthAnchor.constraint(equalToConstant: self.view.bounds.height * (45 / 844)),
                    self.buttonRoute.heightAnchor.constraint(equalToConstant: self.view.bounds.height * (45 / 844)),
                ])
            }
        }
    }
    
    func appendAnnotationData(typeFeature: String, parsedFeature: Dictionary<String, JSONValue>, locationCoordinate: CLLocationCoordinate2D, distance: Double = 0.0, travelTime: Double = 0.0) {
        if typeFeature == "Hewan" {
            var dict = parsedFeature
            let clusterName = getClusterName(idName: parsedFeature["cage"]!.rawValue as! String)
            dict["clusterName"] = JSONValue(clusterName)
            self.animalsData.append(
                AllData(
                    cage: parsedFeature["cage"]!.rawValue as! String,
                    idName: parsedFeature["idName"]!.rawValue as! String,
                    enName: parsedFeature["enName"]!.rawValue as! String,
                    latinName: parsedFeature["latinName"]!.rawValue as! String,
                    type: parsedFeature["type"]!.rawValue as! String,
                    clusterName: clusterName,
                    lat: locationCoordinate.latitude,
                    long: locationCoordinate.longitude,
                    distance: Int(distance),
                    travelTime: Int(travelTime),
                    dict: dict
                )
            )
        } else if typeFeature != "Kandang" && typeFeature != "Hewan" {
            self.facilitiesData.append(
                AllData(
                    cage: "",
                    idName: parsedFeature["idName"]!.rawValue as! String,
                    enName: parsedFeature["enName"]!.rawValue as! String,
                    latinName: "",
                    type: parsedFeature["type"]!.rawValue as! String,
                    clusterName: parsedFeature["clusterName"]!.rawValue as! String,
                    lat: locationCoordinate.latitude,
                    long: locationCoordinate.longitude,
                    distance: Int(distance),
                    travelTime: Int(travelTime),
                    dict: parsedFeature
                )
            )
        }
    }
    
    func clickFacility() {
        var customPointAnnotation = PointAnnotation(coordinate: self.targetCoordinate)
        if (self.pointAnnotationManager != nil) {
            self.pointAnnotationManager.annotations = []
        }
        self.pointAnnotationManager = self.mapView.annotations.makePointAnnotationManager()
        let uuid = NSUUID().uuidString
        customPointAnnotation.image = .init(image: UIImage(named: "\(annotationData["clusterName"]!.rawValue) Active")!, name: "\(annotationData["clusterName"]!.rawValue) Active-\(uuid)")
        self.pointAnnotationManager.annotations = [customPointAnnotation]
        self.removeSubview()
        self.showOverview()
        selectedSegmentIndex = 2
        for (i, btn) in segmentedButtons.enumerated() {
            if i == 2 {
                let selectorStartPosition = (segmentedBase.frame.width / CGFloat(segmentedButtons.count) * CGFloat(i))
                UIView.animate(withDuration: 0.3) {
                    self.segmentedSelector.frame.origin.x = selectorStartPosition
                }
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            } else {
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                segmentedButtons[i].setTitleColor(.SecondaryText, for: .normal)
            }
        }
        self.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapFasilitasStyleURI)
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
                    self!.annotationData = dict
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
                        switch self!.selectedSegmentIndex {
                        case 1:
                            self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapKandangDisableStyleURI)
                        case 2:
                            self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapFasilitasStyleURI)
                        default:
                            self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapAllDisableStyleURI)
                        }
                    }
                } else {
                    if (self!.pointAnnotationManager != nil) {
                        self!.pointAnnotationManager.annotations = []
                        self!.removeSubview()
                        switch self!.selectedSegmentIndex {
                        case 1:
                            self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapKandangDefaultStyleURI)
                        case 2:
                            self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapFasilitasStyleURI)
                        default:
                            self!.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapAllDefaultStyleURI)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    func showOverview() {
        if self.view.viewWithTag(8) != nil {
            buttonClosePopUpAction()
        }
        let type = annotationData["type"]!.rawValue as? String
        lazy var overviewCardView: OverviewCardView = {
            let oVview = OverviewCardView()
            oVview.translatesAutoresizingMaskIntoConstraints = false
            oVview.tag = 1
            let idName = annotationData["idName"]!.rawValue as? String
            let clusterName = annotationData["clusterName"]!.rawValue as? String
            oVview.title = idName
            oVview.type = type
            oVview.targetCoordinate = targetCoordinate
            
            let imageView = UIImageView(image: UIImage(named: (type == "Kandang" ? idName : clusterName)!))
            imageView.frame = .zero
            imageView.translatesAutoresizingMaskIntoConstraints = false
            oVview.addSubview(imageView)
            
            imageView.anchor(
                bottom: oVview.bottomAnchor,
                left: oVview.rightAnchor,
                paddingBottom: -(type == "Kandang" ? 54 : 10),
                paddingLeft: -(view.bounds.height * ((type == "Kandang" ? 115 : 85) / 844)),
                width: view.bounds.height * ((type == "Kandang" ? 260 : 180) / 844),
                height: view.bounds.height * ((type == "Kandang" ? 260 : 180) / 844)
            )
            
            return oVview
        }()
        
        if type == "Kandang" {
            overviewCardView.overviewButton.addTarget(self, action: #selector(onOverviewClick), for: .touchUpInside)
        } else {
            overviewCardView.startJourneyButton.addTarget(self, action: #selector(onJourneyClick), for: .touchUpInside)
        }
        
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
    
    @objc private func onOverviewClick(_ sender: UIButton) {
        animalDetailViewController = AnimalDetailViewController()
        animalDetailViewController.modalPresentationStyle = .fullScreen
        animalDetailViewController.detailData = annotationData
        animalDetailViewController.targetCoordinate = targetCoordinate
        animalDetailViewController.userLocation = userLocation
        animalDetailViewController.animalsData = animalsData
        self.present(animalDetailViewController, animated: true, completion: nil)
    }
    
    @objc private func onJourneyClick(_ sender: UIButton) {
        isOnJourneyClick = true
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
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if !MainViewController.isOutsideArea {
                startNavigation()
            } else {
                self.present(outsideAreaAlert, animated: true)
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            self.present(alertController, animated: true, completion: nil)
        default :
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    @objc private func centerLocation() {
         mapView?.camera.ease(
             to: CameraOptions(center: userLocation, zoom: 16),
             duration: 1.0)
    }
    
    func removeSubview(tag: Int? = 1){
        if let viewWithTag = self.view.viewWithTag(tag!) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func segmentedBackground() {
        view.safeAreaLayoutGuide.owningView?.backgroundColor = .white
        whiteBackground = SegmentedControl.whiteBackground
        view.addSubview(whiteBackground)
        
        // Set the Constraints of the for the Segmented Background Programmatically (With an Array of NSLayoutConstraint)
        NSLayoutConstraint.activate([
            whiteBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            whiteBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            whiteBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            whiteBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.size.height*0.88))
        ])
    }
    
    // MARK: - CUSTOM SEGMENTED CONTROL FUNCTION
    func customSegmentedControl() {
        segmentedBase = SegmentedControl.segmentedBase
        view.addSubview(segmentedBase)
        segmentedButtons = SegmentedControl.segmentedButtons
        let segmentedStackView = SegmentedControl.segmentedStackView
        for button in segmentedButtons {
            button.addTarget(self, action: #selector(segmentedButtonTapped(_:)), for: .touchUpInside)
            segmentedStackView.addArrangedSubview(button)
        }
        segmentedSelector = SegmentedControl.segmentedSelector
        segmentedBase.addSubview(segmentedSelector)
        segmentedBase.addSubview(segmentedStackView)
        
        segmentedStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.size.width*0.04),
            segmentedStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.size.width*0.04)),
            segmentedStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56) // 12.5/57 = 0.21
        ])
    }
    
    func setupConstraint() {
        NSLayoutConstraint.activate([
            whiteBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            whiteBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            whiteBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            whiteBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.size.height*0.88)),
            segmentedBase.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.size.width*0.04),
            segmentedBase.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.size.width*0.04)),
            segmentedBase.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            segmentedBase.heightAnchor.constraint(equalToConstant: 32),
            mapViewRetrieveData.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapViewRetrieveData.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapViewRetrieveData.widthAnchor.constraint(equalToConstant: 100),
            mapViewRetrieveData.heightAnchor.constraint(equalToConstant: 100),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: whiteBackground.bottomAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 16),
            searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: view.bounds.height * (45 / 844)),
            searchButton.heightAnchor.constraint(equalToConstant: view.bounds.height * (45 / 844))
        ])
    }
    
    func getRouteInformation() {
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: userLocation!, name: "origin"),
            Waypoint(coordinate: ragunanCoordinate, name: "ragunan"),
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
                
                let distance = Int(route.distance)
                if distance > 1500 {
                    MainViewController.isOutsideArea = true
                    if AnimalDetailViewController.isOnJourneyClick {
                        self.animalDetailViewController.userLocation = self.userLocation
                    } else {
                        self.present(self.outsideAreaAlert, animated: true)
                    }
                } else {
                    if AnimalDetailViewController.isOnJourneyClick {
                        self.animalDetailViewController.userLocation = self.userLocation
                        self.removeSubview(tag: 7)
                        self.view.addSubview(self.centerLocationButton)
                        self.centerLocationButton.anchor(
                            top: self.searchButton.bottomAnchor,
                            right: self.view.rightAnchor,
                            paddingTop: 10,
                            paddingRight: 16,
                            width: self.view.bounds.height * (45 / 844),
                            height: self.view.bounds.height * (45 / 844)
                        )
                        self.view.addSubview(self.buttonRoute)
                        self.buttonRoute.anchor(
                            top: self.centerLocationButton.bottomAnchor,
                            right: self.view.rightAnchor,
                            paddingTop: 10,
                            paddingRight: 16,
                            width: self.view.bounds.height * (45 / 844),
                            height: self.view.bounds.height * (45 / 844)
                        )
                    }
                    if self.isButtonLocationOffClick {
                        self.removeSubview(tag: 7)
                        self.view.addSubview(self.centerLocationButton)
                        self.centerLocationButton.anchor(
                            top: self.searchButton.bottomAnchor,
                            right: self.view.rightAnchor,
                            paddingTop: 10,
                            paddingRight: 16,
                            width: self.view.bounds.height * (45 / 844),
                            height: self.view.bounds.height * (45 / 844)
                        )
                        self.view.addSubview(self.buttonRoute)
                        self.buttonRoute.anchor(
                            top: self.centerLocationButton.bottomAnchor,
                            right: self.view.rightAnchor,
                            paddingTop: 10,
                            paddingRight: 16,
                            width: self.view.bounds.height * (45 / 844),
                            height: self.view.bounds.height * (45 / 844)
                        )
                    }
                    if self.isOnJourneyClick {
                        self.startNavigation()
                    }
                }
            }
        }
    }
    
    // Objective-C Function for the segmentedSelector action
    @objc func segmentedButtonTapped(_ button: UIButton) {
        // buttonIndex = to get the Current index; btn = the Current UIButton
        for (buttonIndex, btn) in segmentedButtons.enumerated() {
            // When the button is not selected, the text color is gray
            btn.setTitleColor(UIColor.SecondaryText, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            
            // If the button is Clicked
            if btn == button {
                selectedSegmentIndex = buttonIndex
                
                // Animate the segmentedSelector
                let selectorStartPosition = (segmentedBase.frame.width / CGFloat(segmentedButtons.count) * CGFloat(buttonIndex))
                UIView.animate(withDuration: 0.3) {
                    self.segmentedSelector.frame.origin.x = selectorStartPosition
                }
                
                // Change the Selected Text Color to White & Bold
                btn.setTitleColor(.white, for: .normal)
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                if (self.pointAnnotationManager != nil) {
                    self.removeSubview()
                    self.pointAnnotationManager.annotations = []
                }
                // Change the MapView for Each Segmented Control Options
                switch selectedSegmentIndex {
                    // Case 0: If the user select the First Segmented Control Option "Semua" -> See All of the Map Anotations
                case 0:
                    self.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapAllDefaultStyleURI)
                    
                    // Case 1: If the user select the First Segmented Control Option "Kandang" -> See the Cages Only Map Anotations
                case 1:
                    self.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapKandangDefaultStyleURI)
                    
                    // Case 2: If the user select the First Segmented Control Option "Fasilitas" -> See the Facility Only Map Anotations
                case 2:
                    self.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapFasilitasStyleURI)
                    
                    // default: The Default Map -> See All of the Map Anotations
                default:
                    self.mapView.mapboxMap.style.uri = StyleURI(rawValue: mapAllDefaultStyleURI)
                }
                
            }
        }
    }
    
    // MARK: - ANIMATED MONKEY (LOCATION OFF BUTTON FUNCTION)
    func locationOffButton() {
        buttonLocationOFF = MonkeyLocationButton()
        buttonLocationOFF.addTarget(self, action: #selector(buttonLocationOFFAction(_:)), for:.touchUpInside)
        view.addSubview(buttonLocationOFF)
        
        buttonLocationOFF.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            width: 205,
            height: 227
        )
    }
    
    // MARK: - Show the Location Permission After The User Tapped the Monkey Button by Representing the CLLocationManagerDelegate
    @objc func buttonLocationOFFAction(_ button: UIButton) {
        // Give some conditions where the Monkey can be pressed and it will show the location permission
        isButtonLocationOffClick.toggle()
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
        
        switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
            case .restricted, .denied:
                self.present(alertController, animated: true, completion: nil)
            default :
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
        }
    }
    
    // MARK: - POP-UP ROUTE FUNCTION
    func popUpRute() {
        // Add the White Containter with AutoLayout Constraints
        // Source 1: www.developer.apple.com/forums/thread/656789
        // Source 2: www.stackoverflow.com/questions/43550813/property-initializers-run-before-self-is-available
        container.backgroundColor = .white
        container.frame = CGRect(x: 16, y: 620, width: 358, height: 190) // CGRectMake(x, y, width, height)
    //        container.frame = CGRect(x: 16, y: 620, width: self.frame.size.width*(358/375), height: self.frame.size.height*(190/844)) // CGRectMake(x, y, width, height)
        container.layer.cornerRadius = 20
        container.tag = 8
        view.addSubview(container)
        
        // Set the Constraints of the container Programmatically (With an Array of NSLayoutConstraint)
        container.translatesAutoresizingMaskIntoConstraints = false // Activate the Auto Layout
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.size.width*(16/375)),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(view.frame.size.width*(16/375))),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(view.safeAreaLayoutGuide.layoutFrame.height*(16/(844-81)))),
            container.heightAnchor.constraint(equalToConstant: 190),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Showing the Route Image
        let routeIconImage = UIImage(named: "RouteIcon")
        let routeIconImageView = UIImageView(image: routeIconImage)
        routeIconImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        container.addSubview(routeIconImageView)
        
        // Set the Constraints of the routeIconImageView Programmatically (With an Array of NSLayoutConstraint)
        routeIconImageView.translatesAutoresizingMaskIntoConstraints = false // Activate the Auto Layout
        NSLayoutConstraint.activate([
            routeIconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: container.frame.size.width*(16/358)),
            routeIconImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: container.frame.size.height*(16/190)),
            routeIconImageView.heightAnchor.constraint(equalToConstant: 30),
            routeIconImageView.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        // Showing the Title Label
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.text = "Kamu belum memiliki rute"
        container.addSubview(titleLabel)
        
        // Set the Constraints of the titleLabel Programmatically (With an Array of NSLayoutConstraint)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false // Activate the Auto Layout
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: routeIconImageView.trailingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: routeIconImageView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 222)
        ])
        
        // Showing the Close Button Image & Customize the Button Color & Size
        let closeButtonImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.SecondaryBrown, renderingMode: .alwaysOriginal).resizeImageTo(size: CGSize(width: 26, height: 26))
        
        // Create a Button with an Image
        let closeButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        closeButton.setImage(closeButtonImage, for: .normal)
        closeButton.addTarget(self, action: #selector(buttonClosePopUpAction), for:.touchUpInside)
        container.addSubview(closeButton)
        
        // Set the Constraints of the closeButton Programmatically (With an Array of NSLayoutConstraint)
        closeButton.translatesAutoresizingMaskIntoConstraints = false // Activate the Auto Layout
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: routeIconImageView.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -(container.frame.size.width*(16/358))),
            closeButton.heightAnchor.constraint(equalToConstant: 26),
            closeButton.widthAnchor.constraint(equalToConstant: 26)
        ])
        
        // Showing the Subtitle Label
        let subtitlelabel = UILabel()
        subtitlelabel.textColor = .black
        subtitlelabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitlelabel.text = "Ayo! Pilih binatang yang ingin kamu lihat dan kunjungi!"
        subtitlelabel.numberOfLines = 2
        // Add Spacing between lines using the UILabel Extension (Thanks to Levina for Finding the Source)
        subtitlelabel.addInterlineSpacing(spacingValue: 10)
        container.addSubview(subtitlelabel)
        
        // Set the Constraints of the subtitlelabel Programmatically (With an Array of NSLayoutConstraint)
        subtitlelabel.translatesAutoresizingMaskIntoConstraints = false // Activate the Auto Layout
        NSLayoutConstraint.activate([
            subtitlelabel.leadingAnchor.constraint(equalTo: routeIconImageView.leadingAnchor),
            subtitlelabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -(container.frame.size.width*(41/358))),
            subtitlelabel.topAnchor.constraint(equalTo: routeIconImageView.bottomAnchor, constant: 12),
        ])
        
    
        // Showing Jeera Custom Button: "Create Route Button"
        let createRouteButton = UIButton(type: .custom)
        createRouteButton.backgroundColor = .PrimaryGreen
        createRouteButton.frame = CGRect(x: 0, y: 0, width: 326, height: 48)
        createRouteButton.layer.cornerRadius = createRouteButton.frame.height / 2
        createRouteButton.setTitle("Yuk! Buat Sekarang", for: .normal)
        createRouteButton.setTitleColor(.white, for: .normal)
        createRouteButton.addTarget(self, action: #selector(createRouteAction), for:.touchUpInside)
        container.addSubview(createRouteButton)
        
        
        // Set the Constraints of the closeButton Programmatically (With an Array of NSLayoutConstraint)
        createRouteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createRouteButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: container.frame.size.width*(16/358)),
            createRouteButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            createRouteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -(container.frame.size.width*(16/358))),
            createRouteButton.topAnchor.constraint(equalTo: subtitlelabel.bottomAnchor, constant: 12),
            createRouteButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    
    }
    
    // Objective-C Function for the buttonClosePopUp Action
    @objc func buttonClosePopUpAction() {
//        print("THE USER CLOSE THE POP UP")
        
        // Animate Out the Pop-Up Route + Spring Animation
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            let minimizeRouteBtn = CGAffineTransform(translationX: 150, y: -490)
            self.container.transform = CGAffineTransformScale(minimizeRouteBtn, (45/358), (45/190)) // Make the Container Small as the routeBtn
            self.container.alpha = 0 // Change the Opacity or the Alpha to 0
        }) { (complete) in
            if complete {
                self.container.removeFromSuperview() // Remove the Pop-Up Route View
            }
        }
        
        // Animate In the buttonRoute + Spring Animation
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.buttonRoute.transform = CGAffineTransform(scaleX: (45/358), y: (45/190)) // Make the Container Small as the routeBtn
            self.buttonRoute.transform = .identity // Bringing Back the Initial State
            self.buttonRoute.alpha = 1 // Change the Opacity or the Alpha to 1
        })
    }
    
    // Objective-C Function for the createRoute Action
    @objc func createRouteAction(_ button: UIButton) {
        let routePlanViewController = RoutePlanViewController()
        routePlanViewController.modalPresentationStyle = .formSheet
        routePlanViewController.animalsData = self.animalsData
        self.present(routePlanViewController, animated: true, completion: nil)
    }
    
    // MARK: - Route Button Function
    func routeButton() {
        
        // Create the Route Button with an Image from Assets
        let imageRouteBtn = UIImage(named: "RouteBtn")
//        buttonRoute.frame = CGRectMake(329, 184, 45, 45) // CGRectMake(x, y, width, height)
        buttonRoute.setImage(imageRouteBtn, for: .normal)
        buttonRoute.addTarget(self, action: #selector(createRouteAction), for:.touchUpInside)
        
        buttonRoute.alpha = 0
        buttonRoute.tag = 7
        view.addSubview(buttonRoute)
        
        // Set the Constraints of the buttonSearch Programmatically (With an Array of NSLayoutConstraint)
        buttonRoute.translatesAutoresizingMaskIntoConstraints = false // Disable the Auto Resizing to Auto Layout
        NSLayoutConstraint.activate([
            buttonRoute.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            buttonRoute.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 10),
            buttonRoute.widthAnchor.constraint(equalToConstant: view.bounds.height * (45 / 844)),
            buttonRoute.heightAnchor.constraint(equalToConstant: view.bounds.height * (45 / 844)),
        ])
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
