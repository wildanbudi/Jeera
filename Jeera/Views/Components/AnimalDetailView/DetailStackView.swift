//
//  DetailStackView.swift
//  Jeera
//
//  Created by Anggi Dastariana on 06/11/22.
//

import UIKit

class DetailStackView: UIStackView {
    init(spacing: CGFloat) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
