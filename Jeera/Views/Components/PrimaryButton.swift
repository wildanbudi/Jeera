//
//  PrimaryButton.swift
//  Jeera
//
//  Created by Wildan Budi on 01/11/22.
//

import Foundation
import UIKit

class PrimaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .PrimaryGreen
        config.baseForegroundColor = .white
        config.titleTextAttributesTransformer =
          UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            return outgoing
          }
        
        self.configuration = config
        self.tintColor = .white
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
