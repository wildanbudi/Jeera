//
//  CustomBottomBannerView.swift
//  Jeera
//
//  Created by Wildan Budi on 22/10/22.
//

import UIKit
import MapboxNavigation

protocol CustomBottomBannerViewDelegate: AnyObject {
func customBottomBannerDidCancel(_ banner: CustomBottomBannerView)
}

class CustomBottomBannerView: UIView {
    
    lazy var bannerView: BottomBanner = {
    let banner = BottomBanner()
    banner.translatesAutoresizingMaskIntoConstraints = false
//    banner.delegate = self
    return banner
    }()
    
    weak var delegate: CustomBottomBannerViewDelegate?
    
    init() {
        super.init(frame: .zero)
//        self.backgroundColor = .red
        self.addSubview(bannerView)
        let safeArea = self.layoutMarginsGuide
        NSLayoutConstraint.activate([
        bannerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
        bannerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        bannerView.heightAnchor.constraint(equalTo: self.heightAnchor),
        bannerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI

@available(iOS 13, *)
struct CustomBottomBannerViewPreview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            CustomBottomBannerView().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
