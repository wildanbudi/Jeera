//
//  RoutePlanViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 17/11/22.
//

import UIKit
import CoreLocation
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

class RoutePlanViewController: UIViewController, UITableViewDelegate {
    var animalsData: [AllData]!
    var cagesData: [AllData]!
    var searchResults: [AllData] = []
    var nonDuplicateNames: [String] = []
    var userLocation: CLLocationCoordinate2D! {
        didSet {
            if RoutePlanViewController.isOnMultiJourneyClick {
                mappingMultiRouteData()
            }
        }
    }
    let searchResultTableView = UITableView()
    let identifier = "RoutePlanTableViewCell"
    var initialDataTemp: [AllData] = []
    var isSearching: Bool = false
    var animalsChoice: [AllData]!
    private (set) static var isOnMultiJourneyClick = false
    
    lazy var searchBar: UISearchBar = {
        let searchBar = SearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    lazy var modalLabel: UILabel = {
        let label = BasicModalLabel()
        label.text = "Yuk! Tentukan Rutemu"
        
        return label
    }()
    
    lazy var saveRouteButton: UIButton = {
        let button = PrimaryButton(frame: .zero)
//        button.setTitle("Simpan Pilihan", for: .normal)
        button.setTitle("Mulai Perjalanan", for: .normal)
        button.addTarget(self, action: #selector(saveRouteButtonClick), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func saveRouteButtonClick() {
        RoutePlanViewController.isOnMultiJourneyClick = true
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
            if !MainViewController.isOutsideArea {
                mappingMultiRouteData()
            } else {
                self.present(self.outsideAreaAlert, animated: true)
            }
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
//            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(startNavigation), userInfo: nil, repeats: true)
        case .restricted, .denied:
            self.present(alertController, animated: true, completion: nil)
        default :
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func mappingMultiRouteData() {
        animalsChoice = initialDataTemp.filter({ (animal: AllData) -> Bool in
            return animal.isChecked == true
        })
        for (i, animal) in animalsChoice.enumerated() {
            let isLastIndex = i+1 == animalsChoice.count
            getRouteInformation(choiceIdx: i, targetCoordinate: CLLocationCoordinate2D(latitude: animal.lat, longitude: animal.long), isLastIndex: isLastIndex)
        }
    }
    
    lazy var buttonContainer: UIView = {
        let containerView = UIView()
        containerView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor  
        containerView.layer.cornerRadius = 20
        containerView.addSubview(saveRouteButton)
        
        return containerView
    }()
    
    lazy var emptyResultView = EmptySearchResultView(frame: CGRect(x: 0, y: 0, width: view.bounds.height * (250/787), height: view.bounds.height * (250/787)))
    
    lazy var outsideAreaAlert = UIAlertController.outsideArea()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        animalsData.sort(by: { $0.idName < $1.idName })
        showInitialData()
    }
    
    func setupView() {
        view.backgroundColor = .white
        [searchBar, modalLabel, searchResultTableView, buttonContainer].forEach {
            view.addSubview($0)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupTableView()
    }
    
    func showInitialData() {
        searchBar.searchTextField.font = UIFont(name: "Baloo2-Regular", size: 17)
        nonDuplicateNames.removeAll()
        for el in animalsData {
            if !nonDuplicateNames.contains(el.idName) {
                nonDuplicateNames.append(el.idName)
                searchResults.append(el)
            }
        }
        initialDataTemp = searchResults
    }
    
    func getRouteInformation(choiceIdx: Int, targetCoordinate: CLLocationCoordinate2D, isLastIndex: Bool) {
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
                
                self.animalsChoice[choiceIdx].distance = Int(route.distance)
                if isLastIndex {
                    self.animalsChoice.sort { $0.distance < $1.distance }
                    self.startNavigation(animalsChoice: self.animalsChoice)
                }
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupTableView() {
        searchResultTableView.register(BasicTableViewCell.self, forCellReuseIdentifier: identifier)
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.separatorStyle = .none
        searchResultTableView.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            paddingRight: 16,
            height: 36
        )
        
        modalLabel.anchor(
            top: searchBar.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 20,
            paddingLeft: 24,
            height: view.bounds.height * (22/787)
        )
        
        saveRouteButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            left: view.leftAnchor,
            paddingLeft: 16,
            height: view.bounds.height * (50/787)
        )
        saveRouteButton.centerX(inView: view)
        
        buttonContainer.anchor(
            top: saveRouteButton.topAnchor,
            bottom: view.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: -20
        )
        
        searchResultTableView.anchor(
            top: modalLabel.bottomAnchor,
            bottom: buttonContainer.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 10
        )
    }

}

extension RoutePlanViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BasicTableViewCell
        cell.cellName = searchResults[indexPath.row].idName
        cell.isChecked = searchResults[indexPath.row].isChecked
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * (112/787)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSearching {
            searchResults[indexPath.row].isChecked?.toggle()
            initialDataTemp = searchResults
        } else {
            let idx = initialDataTemp.firstIndex(of: searchResults[indexPath.row])
            initialDataTemp[idx!].isChecked?.toggle()
            searchResults[indexPath.row].isChecked?.toggle()
        }
    }
}

extension RoutePlanViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        if let viewWithTag = self.view.viewWithTag(6) {
            viewWithTag.removeFromSuperview()
        }
        if searchText != "" {
            isSearching = true
            searchBar.searchTextField.font = UIFont(name: "Baloo2-SemiBold", size: 17)
            let animalsResults = initialDataTemp.filter({ (animal: AllData) -> Bool in
                let idNameMatch = animal.idName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let cageMatch = animal.cage.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return idNameMatch != nil || cageMatch != nil
            })
            if animalsResults.count > 0 {
                nonDuplicateNames.removeAll()
                for el in animalsResults {
                    if !nonDuplicateNames.contains(el.idName) {
                        nonDuplicateNames.append(el.idName)
                        searchResults.append(el)
                    }
                }
            } else {
                emptyResultView.tag = 6
                view.addSubview(emptyResultView)
                emptyResultView.center(inView: view, yConstant: view.bounds.height * (-100/787))
            }
        } else {
            isSearching = false
            searchResults = initialDataTemp
        }
        searchResultTableView.reloadData()
    }
}

extension RoutePlanViewController {
    func startNavigation(animalsChoice: [AllData]) {
        if userLocation != nil && !MainViewController.isOutsideArea {
            var waypoints: [Waypoint] = [Waypoint(coordinate: userLocation!, name: "user")]
            for data in animalsChoice {
                waypoints.append(Waypoint(coordinate: CLLocationCoordinate2D(latitude: data.lat, longitude: data.long), name: data.idName))
            }
            
            // Set options
            let routeOptions = NavigationRouteOptions(waypoints: waypoints, profileIdentifier: ProfileIdentifier(rawValue: "mapbox/walking"))
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
                    
                    bottomBanner.routePlanViewController = self
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
        } else if MainViewController.isOutsideArea {
            self.present(outsideAreaAlert, animated: true)
        }
    }
}
