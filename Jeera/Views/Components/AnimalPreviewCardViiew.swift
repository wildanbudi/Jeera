//
//  AnimalPreviewCardView.swift
//  Jeera
//
//  Created by Anggi Dastariana on 24/10/22.
//
import UIKit

class AnimalPreviewCardView: UIView {

    var title: String? {
        get { centerLabel.text }
        set { centerLabel.text = newValue }
    }
    
    lazy var centerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(centerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
