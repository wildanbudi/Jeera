//
//  MonkeyLocationButton.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import UIKit

class MonkeyLocationButton: UIButton {
    lazy var imageLocationOFF = UIImage(named: "Lokasi Mati Button")

    init() {
        super.init(frame: .zero)
        self.setImage(imageLocationOFF, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.rotate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
