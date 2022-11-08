//
//  BottomBarView.swift
//  Jeera
//
//  Created by Wildan Budi on 01/11/22.
//

import UIKit
import MapboxNavigation

protocol BottomBarViewDelegate: AnyObject {
    func customBottomBannerDidCancel(_ banner: BottomBarView)
}

class BottomBarView: UIView {

    lazy var animalLabel = HeadingLabel()
    lazy var etaLabel = CaptionLabel()
    lazy var endButton = PrimaryButton()
    
    weak var delegate: BottomBarViewDelegate?
        
    var eta: String? {
        get {
            return etaLabel.text
        }
        set {
            etaLabel.text = newValue
        }
    }
    
    var animalName: String? {
        get {
            return animalLabel.text
        }
        set {
            animalLabel.text = newValue
        }
    }
    
    init () {
        super.init(frame: .zero)
        backgroundColor = .white
        
        addSubViews()
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        [animalLabel, etaLabel, endButton]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setUpViews() {    
        etaLabel.font = UIFont.systemFont(ofSize: 22)
        
        endButton.setTitle("Akhiri Rute", for: .normal)
        endButton.addTarget(self, action: #selector(onCancelClick), for: .touchUpInside)
    }
    
    private func setUpConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        animalLabel.anchor(
         top: self.safeAreaLayoutGuide.topAnchor,
         bottom: etaLabel.topAnchor,
         left: self.leftAnchor,
         right: self.rightAnchor,
         paddingTop: 8,
         paddingBottom: 9,
         paddingLeft: 16,
         paddingRight: 16
        )
        
        etaLabel.anchor(
         top: animalLabel.bottomAnchor,
         bottom: endButton.topAnchor,
         left: self.leftAnchor,
         right: self.rightAnchor,
         paddingBottom: 9,
         paddingLeft: 16,
         paddingRight: 16
        )
        
        endButton.anchor(
         top: etaLabel.bottomAnchor,
         left: self.leftAnchor,
         right: self.rightAnchor,
         paddingBottom: 34,
         paddingLeft: 16,
         paddingRight: 16,
         height: 50
        )
    }
    
    @objc func onCancelClick(_ sender: UIButton) {
        print("tapped")
        delegate?.customBottomBannerDidCancel(self)
    }

}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct BottomBarViewPreview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            BottomBarView().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
#endif
