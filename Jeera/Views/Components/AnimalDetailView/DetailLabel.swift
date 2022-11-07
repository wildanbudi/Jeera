//
//  DetailLabel.swift
//  Jeera
//
//  Created by Anggi Dastariana on 06/11/22.
//

import UIKit

class DetailLabel: UILabel {
    init() {
        super.init(frame: .zero)
        self.font = UIFont(name: "Baloo2-Bold", size: 30)
        self.numberOfLines = 2
        self.textColor = .PrimaryText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
