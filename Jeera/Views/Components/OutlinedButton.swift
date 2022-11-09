//
//  OutlinedButton.swift
//  Jeera
//
//  Created by Anggi Dastariana on 09/11/22.
//

import UIKit

class OutlinedButton: UIButton {
    
    init(title: String, iconName: String? = nil, textWeight: UIFont.Weight? = .semibold) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = .PrimaryGreen
        config.titleTextAttributesTransformer =
          UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
              outgoing.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            return outgoing
          }
        if iconName != nil {
          config.image = UIImage(systemName: iconName!)
          config.imagePadding = 5
          config.imagePlacement = .trailing
          config.preferredSymbolConfigurationForImage
          = UIImage.SymbolConfiguration(scale: .large)
        }
        config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
        self.configuration = config
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.PrimaryGreen.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
