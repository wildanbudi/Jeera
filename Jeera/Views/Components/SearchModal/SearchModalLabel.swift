//
//  SearchModalLabel.swift
//  Jeera
//
//  Created by Anggi Dastariana on 07/11/22.
//

import UIKit

class SearchModalLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.font = UIFont(name: "Baloo2-SemiBold", size: 17)
        self.textColor = .PrimaryText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
