//
//  InvisibleLoadingView.swift
//  Jeera
//
//  Created by Anggi Dastariana on 21/11/22.
//

import UIKit

class InvisibleLoadingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
