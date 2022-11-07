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
    let tableView = UITableView()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = SearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    lazy var searchResultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .PrimaryText
        label.font = UIFont(name: "Baloo2-SemiBold", size: 17)
        label.text = "Hewan apa yang kamu cari?"
        
        return label
    }()
    
    lazy var horizontalLine: UIView = {
        let line = UIView()
        line.backgroundColor = .Line
        
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(horizontalLine)
        view.addSubview(searchResultLabel)
        view.addSubview(tableView)
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
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
        
        searchResultLabel.anchor(
            top: searchBar.bottomAnchor,
            left: view.leftAnchor,
            paddingTop: 20,
            paddingLeft: 24,
            height: view.bounds.height * (22/844)
        )
        
        horizontalLine.anchor(
            top: searchResultLabel.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 5,
            paddingLeft: 16,
            paddingRight: 16,
            height: 1
        )
        horizontalLine.centerX(inView: view)
        
        tableView.anchor(
            top: horizontalLine.bottomAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 10,
            height: view.bounds.height
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
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
        cell.cellName = searchResults[indexPath.row].idName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height * (112/844)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animalDetailViewController = AnimalDetailViewController()
        animalDetailViewController.modalPresentationStyle = .fullScreen
        animalDetailViewController.animalData = searchResults[indexPath.row].dict
        animalDetailViewController.targetCoordinate = CLLocationCoordinate2D(latitude: searchResults[indexPath.row].lat, longitude: searchResults[indexPath.row].long)
        animalDetailViewController.userLocation = userLocation
        animalDetailViewController.distance = searchResults[indexPath.row].distance
        animalDetailViewController.travelTime = searchResults[indexPath.row].travelTime
        self.present(animalDetailViewController, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchBar.searchTextField.font = UIFont(name: "Baloo2-SemiBold", size: 17)
        } else {
            searchResults.removeAll()
            searchBar.searchTextField.font = UIFont(name: "Baloo2-Regular", size: 17)
        }
        if searchText.count > 2 {
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
                let results = animalsResults.sorted { $0.distance < $1.distance } + facilitiesResults.sorted { $0.distance < $1.distance }
                nonDuplicateNames.removeAll()
                searchResults.removeAll()
                for el in results {
                    if !nonDuplicateNames.contains(el.idName) {
                        nonDuplicateNames.append(el.idName)
                        searchResults.append(el)
                    }
                }
            }
        }
        tableView.reloadData()
    }
}
