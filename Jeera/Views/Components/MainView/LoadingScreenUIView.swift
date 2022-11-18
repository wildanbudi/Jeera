//
//  LoadingScreenUIView.swift
//  Jeera
//
//  Created by Anggi Dastariana on 12/11/22.
//

import UIKit

class LoadingScreenUIView: UIView {
    lazy var loadingImage = UIImageView(image: UIImage(named: "Loading Kosong"))
    
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Baloo2-Bold", size: 17)
        label.textColor = .white
        label.text = "Mencari lokasi saat ini"
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(red: 0.435, green: 0.435, blue: 0.439, alpha: 0.4)
        self.addSubview(loadingImage)
        self.addSubview(loadingLabel)
        setupConstraint()
    }
    
    func setupConstraint() {
        loadingImage.anchor(
            width: 270,
            height: 227
        )
        loadingImage.center(inView: self)
        
        loadingLabel.anchor(
            height: 22
        )
        loadingLabel.center(inView: self, yConstant: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
