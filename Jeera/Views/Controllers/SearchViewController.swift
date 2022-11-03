//
//  SearchViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    func updateSearchResults(for searchController: UISearchController) {
//        <#code#>
//    }
    
    var animalsData: [Animals]!
    var cagesData: [Cages]!
    var facilitiesData: [Facilities]!
    var searchResults: [Any] = []
    let tableView = UITableView()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.showsCancelButton = true
        sb.tintColor = .PrimaryGreen
        sb.setImage(UIImage(systemName: "magnifyingglass")?.imageWithColor(newColor: .PrimaryGreen), for: .search, state: .normal)
        sb.placeholder = "Cari Hewan..."
        sb.becomeFirstResponder()
        sb.searchTextField.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 1)
        sb.searchTextField.font = UIFont(name: "Baloo2-Regular", size: 17)
        sb.searchTextField.layer.cornerRadius = 18
        sb.searchTextField.clipsToBounds = true
        sb.searchTextField.backgroundColor = .white
        sb.searchTextField.layer.borderColor = UIColor.PrimaryGreen.cgColor
        sb.searchTextField.layer.borderWidth = 1
        sb.backgroundImage = UIImage()
        
        sb.delegate = self
        
        return sb
    }()
    
//    lazy var searchController: UISearchController = {
//        let controller = UISearchController(searchResultsController: nil)
//        controller.searchResultsUpdater = self
//        controller.obscuresBackgroundDuringPresentation = false
//        controller.hidesNavigationBarDuringPresentation = false
//        controller.searchBar.tintColor = .PrimaryGreen
//        controller.searchBar.setImage(UIImage(systemName: "magnifyingglass")?.imageWithColor(newColor: .PrimaryGreen), for: .search, state: .normal)
//        controller.searchBar.placeholder = "Cari Hewan..."
//        controller.searchBar.becomeFirstResponder()
//        controller.searchBar.searchTextField.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 1)
//        controller.searchBar.searchTextField.font = UIFont(name: "Baloo2-Regular", size: 17)
//        controller.searchBar.searchTextField.layer.cornerRadius = 18
//        controller.searchBar.searchTextField.clipsToBounds = true
//        controller.searchBar.searchTextField.backgroundColor = .white
//        controller.searchBar.searchTextField.layer.borderColor = UIColor.PrimaryGreen.cgColor
//        controller.searchBar.searchTextField.layer.borderWidth = 1
//        controller.searchBar.backgroundImage = UIImage()
//
//        return controller
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        //        print(animalsData.count, cagesData.count, facilitiesData.count)
        
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
        
//        tableView.tableHeaderView = searchController.searchBar
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.anchor(
//            top: searchBar.bottomAnchor,
//            left: view.leftAnchor,
//            right: view.rightAnchor,
//            paddingTop: 10,
//            height: view.bounds.height
//        )
//    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if facilitiesData.count > 0 {
            return facilitiesData.count
        } else {
            return animalsData.count + cagesData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = animalsData[indexPath.row].idName
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchBar.searchTextField.font = UIFont(name: "Baloo2-SemiBold", size: 17)
        } else {
            searchBar.searchTextField.font = UIFont(name: "Baloo2-Regular", size: 17)
        }
//        searchResults = 
    }
}
