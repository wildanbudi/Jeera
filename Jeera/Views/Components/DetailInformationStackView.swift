//
//  DetailInformationStackView.swift
//  Jeera
//
//  Created by Anggi Dastariana on 06/11/22.
//

import UIKit

class DetailInformationStackView: UIStackView {
    init() {
        super.init(frame: .zero)
        self.axis = NSLayoutConstraint.Axis.horizontal
        self.distribution = UIStackView.Distribution.equalSpacing
        self.alignment = UIStackView.Alignment.fill
        self.spacing = 20.0
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
