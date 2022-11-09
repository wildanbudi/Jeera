//
//  StartJourneyButton.swift
//  Jeera
//
//  Created by Anggi Dastariana on 06/11/22.
//

import UIKit

class StartJourneyButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        var config = UIButton.Configuration.filled()
        config.title = "Mulai Perjalanan"
        config.baseBackgroundColor = .PrimaryGreen
        config.baseForegroundColor = .white
        config.titleTextAttributesTransformer =
          UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            return outgoing
          }
        self.configuration = config
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
