//
//  RoutePlanViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 17/11/22.
//

import UIKit
import CoreLocation

class RoutePlanViewController: UIViewController, UITableViewDelegate {
    var animalsData: [AllData]!
    var cagesData: [AllData]!
    var searchResults: [AllData] = []
    var nonDuplicateNames: [String] = []
    var userLocation: CLLocationCoordinate2D!
    let searchResultTableView = UITableView()
    let identifier = "RoutePlanTableViewCell"
    var initialDataTemp: [AllData] = []
    var isSearching: Bool = false
    
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
        button.setTitle("Simpan Pilihan", for: .normal)
        button.addTarget(self, action: #selector(saveRouteButtonClick), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func saveRouteButtonClick() {
        let animalsChoice = initialDataTemp.filter({ (animal: AllData) -> Bool in
            return animal.isChecked == true
        })
        
        print(animalsChoice.count)
    }
    
    lazy var buttonContainer: UIView = {
        let containerView = UIView()
        containerView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor  
        containerView.layer.cornerRadius = 20
        containerView.addSubview(saveRouteButton)
        
        return containerView
    }()
    
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
            height: view.bounds.height * (22/844)
        )
        
        saveRouteButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            left: view.leftAnchor,
            paddingLeft: 16,
            height: view.bounds.height * (50 / 844)
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
        return view.bounds.height * (112/844)
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
            }
        } else {
            isSearching = true
            searchResults = initialDataTemp
        }
        searchResultTableView.reloadData()
    }
}
