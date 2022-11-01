//
//  SearchButton.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import UIKit

class SearchButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.setImage(UIImage(imageName: "Search Button"), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
