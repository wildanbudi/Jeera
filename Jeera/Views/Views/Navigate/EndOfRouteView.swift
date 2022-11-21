//
//  EndOfRouteView.swift
//  Jeera
//
//  Created by Wildan Budi on 18/11/22.
//

import UIKit

protocol EndOfRouteViewDelegate: AnyObject {
    func endRoute(_ banner: EndOfRouteView)
}

class EndOfRouteView: UIView {

    lazy var endButton = PrimaryButton()
    lazy var animalLabel = HeadingLabel()
    lazy var finishLabel = UILabel()
    
    var animalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    weak var delegate: EndOfRouteViewDelegate?
    
    init () {
        super.init(frame: .zero)
        
        addSubViews()
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        [animalImage,finishLabel, animalLabel, endButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    func setUpViews() {
        
        finishLabel.text = "Sampai di"
        
        endButton.setTitle("Oke!", for: .normal)
        endButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    }
    
    func setUpConstraints() {
        
        animalImage.centerX(inView: self)
        animalImage.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            paddingTop: 75,
            width: 200,
            height: 200)
        
        finishLabel.centerX(inView: animalImage, topAnchor: animalImage.bottomAnchor, paddingTop: 14)
        
        animalLabel.centerX(inView: animalImage, topAnchor: finishLabel.bottomAnchor, paddingTop: 16)
        
        endButton.anchor(
         bottom: safeAreaLayoutGuide.bottomAnchor,
         left: self.leftAnchor,
         right: self.rightAnchor,
         paddingBottom: 34,
         paddingLeft: 16,
         paddingRight: 16,
         height: 50
        )
    }
    
    @objc func onCancelClick(_ sender: UIButton) {
        delegate?.endRoute(self)
    }

}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct EndOfRouteViewPreview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            EndOfRouteView().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
#endif
