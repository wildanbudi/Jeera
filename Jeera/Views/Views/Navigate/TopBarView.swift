//
//  TopBarView.swift
//  Jeera
//
//  Created by Wildan Budi on 02/11/22.
//

import UIKit

class TopBarView: UIView {

    lazy var distanceLabel = HeadingLabel()
    lazy var streetLabel = CaptionLabel()
    
    
    var distance: String? {
        get {
            return distanceLabel.text
        }
        set {
            distanceLabel.text = newValue
        }
    }
    
    var street: String? {
        get {
            return streetLabel.text
        }
        set {
            streetLabel.text = newValue
        }
    }
    
    init () {
        super.init(frame: .zero)
        
        addSubViews()
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        [distanceLabel, streetLabel]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
    }
    
    private func setUpViews() {
        
    }
    
    private func setUpConstraints() {
        let safeArea = safeAreaLayoutGuide
        
        
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TopBarViewPreview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            TopBarView().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
#endif
