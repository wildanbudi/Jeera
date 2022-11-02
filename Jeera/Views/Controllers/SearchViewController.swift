//
//  SearchViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import UIKit

class SearchViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchBar)
        
        searchBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 16,
            paddingRight: 16,
            height: 36
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
    }
}
