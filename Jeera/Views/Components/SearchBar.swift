//
//  SearchBar.swift
//  Jeera
//
//  Created by Anggi Dastariana on 05/11/22.
//

import UIKit

class SearchBar: UISearchBar {
    init() {
        super.init(frame: .zero)
        self.showsCancelButton = true
        self.tintColor = .PrimaryGreen
        self.setImage(UIImage(systemName: "magnifyingglass")?.imageWithColor(newColor: .PrimaryGreen), for: .search, state: .normal)
        self.placeholder = "Cari Hewan..."
        self.searchTextField.textColor = UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 1)
        self.searchTextField.font = UIFont(name: "Baloo2-Regular", size: 17)
        self.searchTextField.layer.cornerRadius = 18
        self.searchTextField.clipsToBounds = true
        self.searchTextField.backgroundColor = .white
        self.searchTextField.layer.borderColor = UIColor.PrimaryGreen.cgColor
        self.searchTextField.layer.borderWidth = 1
        self.backgroundImage = UIImage()
        self.resignFirstResponder()
        
        lazy var upperLabel: UILabel = {
            let label = BasicModalLabel()
            label.text = "Rekomendasi Hewan"
            
            return label
        }()
        
        lazy var upperHorizontalLine = HorizontalLineView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
