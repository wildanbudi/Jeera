//
//  SearchViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var animalsData: [AllData]!
    var facilitiesData: [AllData]!
    var searchResults: [AllData] = []
    var nonDuplicateNames: [String] = []
    var userLocation: CLLocationCoordinate2D!
    let searchResultTableView = UITableView()
    let recommendationsTableView = UITableView()
    let facilitiesTableView = UITableView()
    var animalsRecommendation: [AllData] = []
    var publicFacilities: [AllData] = []
    
    lazy var searchBar: UISearchBar = {
        let searchBar = SearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    lazy var upperLabel: UILabel = {
        let label = BasicModalLabel()
        label.text = "Rekomendasi Hewan"
        
        return label
    }()
    
    lazy var upperHorizontalLine = HorizontalLineView()
    
    lazy var lowerLabel: UILabel = {
        let label = BasicModalLabel()
        label.text = "Fasilitas Umum"
        
        return label
    }()
    
    lazy var emptyResultView = EmptySearchResultView(frame: CGRect(x: 0, y: 0, width: view.bounds.height * (250/787), height: view.bounds.height * (250/787)))
    
    lazy var lowerHorizontalLine = HorizontalLineView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [searchBar, upperLabel, upperHorizontalLine, recommendationsTableView, lowerLabel, lowerHorizontalLine, facilitiesTableView].forEach {
            view.addSubview($0)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setupTableView()
        mappingAnimalsRecommedation()
        mappingPublicFacilities()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupTableView() {
        recommendationsTableView.register(RecommendationsTableViewCell.self, forCellReuseIdentifier: RecommendationsTableViewCell.identifier)
        recommendationsTableView.delegate = self
        recommendationsTableView.dataSource = self
        recommendationsTableView.separatorStyle = .none
        recommendationsTableView.backgroundColor = .white
        recommendationsTableView.alwaysBounceVertical = false
        
        facilitiesTableView.register(FacilitiesTableViewCell.self, forCellReuseIdentifier: FacilitiesTableViewCell.identifier)
        facilitiesTableView.delegate = self
        facilitiesTableView.dataSource = self
        facilitiesTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        facilitiesTableView.backgroundColor = .white
        facilitiesTableView.alwaysBounceVertical = false
        
        searchResultTableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.separatorStyle = .none
        searchResultTableView.tag = 2
        searchResultTableView.backgroundColor = .white
    }
    
    func mappingAnimalsRecommedation() {
        for animalRecoms in ["Flamingo Eropa", "Sendok Raja", "Beruang Madu"] {
            let animalsResult = animalsData.filter({ (animal: AllData) -> Bool in
                let idNameMatch = animal.idName.range(of: animalRecoms, options: NSString.CompareOptions.caseInsensitive)
                return idNameMatch != nil
            })
                animalsRecommendation.append(animalsResult.first!)
        }
    }
    
    func mappingPublicFacilities() {
        publicFacilities.removeAll()
        let facilitiesSorted = facilitiesData.sorted { $0.distance < $1.distance }
        for facility in ["Toilet", "Kantin", "Masjid", "Piknik"] {
            let facilitiesResult = facilitiesSorted.filter({ (facilities: AllData) -> Bool in
                let typeMatch = facilities.type.range(of: facility, options: NSString.CompareOptions.caseInsensitive)
                return typeMatch != nil
            })
            publicFacilities.append(facilitiesResult.first!)
        }
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
        
        upperLabel.anchor(
            top: searchBar.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 20,
            paddingLeft: 24,
            height: view.bounds.height * (22/787)
        )
        
        upperHorizontalLine.anchor(
            top: upperLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 5,
            paddingLeft: 16,
            paddingRight: 16,
            height: 1
        )
        upperHorizontalLine.centerX(inView: view)
        
        recommendationsTableView.anchor(
            top: upperHorizontalLine.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 10,
            height: 255
        )
        
        lowerLabel.anchor(
            top: recommendationsTableView.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 50,
            paddingLeft: 24,
            height: view.bounds.height * (22/787)
        )

        lowerHorizontalLine.anchor(
            top: lowerLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 5,
            paddingLeft: 16,
            paddingRight: 16,
            height: 1
        )
        lowerHorizontalLine.centerX(inView: view)

        facilitiesTableView.anchor(
            top: lowerHorizontalLine.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: 235
        )
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recommendationsTableView {
            return animalsRecommendation.count
        } else if tableView == facilitiesTableView {
            return publicFacilities.count
        }
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == recommendationsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationsTableViewCell.identifier, for: indexPath) as! RecommendationsTableViewCell
            cell.cellName = animalsRecommendation[indexPath.row].idName
            
            return cell
        } else if tableView == facilitiesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: FacilitiesTableViewCell.identifier, for: indexPath) as! FacilitiesTableViewCell
            cell.cellName = publicFacilities[indexPath.row].type
            if indexPath.row == publicFacilities.count - 1 {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude / 2.0)
            }
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath) as! BasicTableViewCell
        cell.cellName = searchResults[indexPath.row].idName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == recommendationsTableView {
            return view.bounds.height * (85/787)
        } else if tableView == facilitiesTableView {
            return view.bounds.height * (58/787)
        }
        return view.bounds.height * (112/787)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == recommendationsTableView {
            let animalDetailViewController = AnimalDetailViewController()
            animalDetailViewController.modalPresentationStyle = .fullScreen
            animalDetailViewController.detailData = animalsRecommendation[indexPath.row].dict
            animalDetailViewController.targetCoordinate = CLLocationCoordinate2D(latitude: animalsRecommendation[indexPath.row].lat, longitude: animalsRecommendation[indexPath.row].long)
            animalDetailViewController.userLocation = userLocation
            animalDetailViewController.distance = animalsRecommendation[indexPath.row].distance
            animalDetailViewController.travelTime = animalsRecommendation[indexPath.row].travelTime
            self.present(animalDetailViewController, animated: true, completion: nil)
        } else if tableView == facilitiesTableView {
            MainViewController.instance.annotationData = publicFacilities[indexPath.row].dict
            MainViewController.instance.targetCoordinate = CLLocationCoordinate2D(latitude: publicFacilities[indexPath.row].lat, longitude: publicFacilities[indexPath.row].long)
            MainViewController.instance.clickFacility()
            self.dismiss(animated: true, completion: nil)
        } else {
            let animalDetailViewController = AnimalDetailViewController()
            animalDetailViewController.modalPresentationStyle = .fullScreen
            animalDetailViewController.detailData = searchResults[indexPath.row].dict
            animalDetailViewController.targetCoordinate = CLLocationCoordinate2D(latitude: searchResults[indexPath.row].lat, longitude: searchResults[indexPath.row].long)
            animalDetailViewController.userLocation = userLocation
            animalDetailViewController.distance = searchResults[indexPath.row].distance
            animalDetailViewController.travelTime = searchResults[indexPath.row].travelTime
            self.present(animalDetailViewController, animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSearchResult() {
        upperLabel.text = "Hewan apa yang kamu cari?"
        view.addSubview(searchResultTableView)
        searchResultTableView.anchor(
            top: upperHorizontalLine.bottomAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 10
        )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        if let viewWithTag = self.view.viewWithTag(6) {
            viewWithTag.removeFromSuperview()
        }
        let animalsResults = animalsData.filter({ (animal: AllData) -> Bool in
            let idNameMatch = animal.idName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let cageMatch = animal.cage.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return idNameMatch != nil || cageMatch != nil
        })
        let facilitiesResults = facilitiesData.filter({ (facilities: AllData) -> Bool in
            let idNameMatch = facilities.idName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return idNameMatch != nil
        })
        if animalsResults.count > 0 || facilitiesResults.count > 0 {
            let results = animalsResults.sorted { $0.idName < $1.idName } + facilitiesResults.sorted { $0.idName < $1.idName }
            nonDuplicateNames.removeAll()
            for el in results {
                if !nonDuplicateNames.contains(el.idName) {
                    nonDuplicateNames.append(el.idName)
                    searchResults.append(el)
                }
            }
        }
        searchResultTableView.reloadData()
        if searchText != "" {
            searchBar.searchTextField.font = UIFont(name: "Baloo2-SemiBold", size: 17)
            showSearchResult()
            if searchResults.count == 0 {
                emptyResultView.tag = 6
                view.addSubview(emptyResultView)
                emptyResultView.center(inView: view, yConstant: view.bounds.height * (-100/787))
            }
        } else {
            searchBar.searchTextField.font = UIFont(name: "Baloo2-Regular", size: 17)
            upperLabel.text = "Rekomendasi Hewan"
            if let viewWithTag = self.view.viewWithTag(2) {
                viewWithTag.removeFromSuperview()
            }
        }
    }
}
