//
//  OverviewCardView.swift
//  Jeera
//
//  Created by Anggi Dastariana on 24/10/22.
//

import UIKit
import CoreLocation

class OverviewCardView: UIView {
    
    var title: String? {
        get { anotationLabel.text }
        set {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.73
            anotationLabel.attributedText = NSMutableAttributedString(string: newValue!, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        }
    }
    var targetCoordinate: CLLocationCoordinate2D?
    var type: String? {
        didSet {
            if type == "Kandang" {
                self.addSubview(overviewButton)
                NSLayoutConstraint.activate([
                    overviewButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                    overviewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                    overviewButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: (39 / 132)),
                    overviewButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (190 / 290))
                ])
            } else {
                self.addSubview(startJourneyButton)
                NSLayoutConstraint.activate([
                    startJourneyButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
                    startJourneyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
                    startJourneyButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: (39 / 132)),
                    startJourneyButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: (190 / 290))
                ])
            }
        }
    }
    
    lazy var anotationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Baloo2-Bold", size: 22)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .PrimaryText
        
        return label
    }()
    
    lazy var overviewButton = OutlinedButton(title: "Yuk! Lihat Aku", iconName: "arrow.right.circle.fill")
    
    lazy var startJourneyButton = OutlinedButton(title: "Mulai Perjalanan")
    
    init() {
        super.init(frame: .zero)    
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.addSubview(anotationLabel)
        
        NSLayoutConstraint.activate([
            anotationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            anotationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -85),
            anotationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

import SwiftUI

@available(iOS 13, *)
struct AnimalOverviewCardPreview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            OverviewCardView().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
