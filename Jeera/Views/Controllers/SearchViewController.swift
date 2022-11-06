//
//  SearchViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var animalsData: [AllData]!
    var cagesData: [AllData]!
    var facilitiesData: [AllData]!
    var searchResults: [AllData] = []
    var nonDuplicateNames: [String] = []
//    var animalsResults: [Animals] = []
//    var cagesResults: [Cages] = []
//    var facilitiesResults: [Facilities] = []
    let tableView = UITableView()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = SearchBar()
        searchBar.delegate = self
        
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
//        print(animalsData!)
        searchBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            paddingRight: 16,
            height: 36
        )
        
        tableView.anchor(
            top: searchBar.bottomAnchor,
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
                let enNameMatch = animal.enName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let cageMatch = animal.cage.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return idNameMatch != nil || enNameMatch != nil || cageMatch != nil
            })
            let cagesResults = cagesData.filter({ (cage: AllData) -> Bool in
                let idNameMatch = cage.idName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let enNameMatch = cage.enName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return idNameMatch != nil || enNameMatch != nil
            })
            let facilitiesResults = facilitiesData.filter({ (facilities: AllData) -> Bool in
                let idNameMatch = facilities.idName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                let enNameMatch = facilities.enName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return idNameMatch != nil || enNameMatch != nil
            })
            if animalsResults.count > 0 || cagesResults.count > 0 || facilitiesResults.count > 0 {
                let results = animalsResults.sorted { $0.distance < $1.distance } + cagesResults.sorted { $0.distance < $1.distance } + facilitiesResults.sorted { $0.distance < $1.distance }
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
