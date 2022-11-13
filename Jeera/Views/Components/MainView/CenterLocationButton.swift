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
        var config = UIButton.Configuration.plain()
        config.title = "Pusatkan"
        config.baseForegroundColor = .PrimaryText
        config.titleTextAttributesTransformer =
          UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
              outgoing.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            return outgoing
          }
        config.image = UIImage(systemName: "location.circle.fill")?.imageWithColor(newColor: .PrimaryGreen)
        config.imagePadding = 10
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage
        = UIImage.SymbolConfiguration(scale: .medium)
        self.configuration = config
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
