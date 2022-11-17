//
//  EmptySearchResultView.swift
//  Jeera
//
//  Created by Anggi Dastariana on 17/11/22.
//

import UIKit

class EmptySearchResultView: UIView {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(imageName: "Ilustrasi Monyet Sedih")
        
        return imageView
    }()
    
    lazy var emptyInformation: UILabel = {
        let label = UILabel()
        label.text = "Yah! Sayang sekali...\nHewan yang kamu cari tidak ada"
        label.font = UIFont(name: "Baloo2-SemiBold", size: 17)
        label.textColor = .SecondaryText
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(imageView)
        self.addSubview(emptyInformation)
        setupConstraint()
    }
    
    func setupConstraint() {
        imageView.anchor(
            top: self.topAnchor,
            width: self.bounds.height * (160/250),
            height: self.bounds.height * (160/250)
        )
        imageView.centerX(inView: self)
        
        emptyInformation.anchor(
            top: imageView.bottomAnchor,
            width: self.bounds.height * (250/250),
            height: self.bounds.height * (60/250)
        )
        emptyInformation.centerX(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
