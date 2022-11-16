//
//  BackButton.swift
//  Jeera
//
//  Created by Anggi Dastariana on 06/11/22.
//

import UIKit

class BackButton: UIButton {
    init() {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: "arrow.left.circle")?
            .resizeImageTo(size: CGSize(width: 30, height: 30))?
            .imageWithColor(newColor: .PrimaryGreen), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
