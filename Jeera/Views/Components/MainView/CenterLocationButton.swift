//
//  CenterLocationButton.swift
//  Jeera
//
//  Created by Anggi Dastariana on 13/11/22.
//

import UIKit

class CenterLocationButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.setImage(UIImage(imageName: "RecenterBtn"), for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
