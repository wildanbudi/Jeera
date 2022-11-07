//
//  HeadingLabel.swift
//  Jeera
//
//  Created by Wildan Budi on 01/11/22.
//

import Foundation
import UIKit

class HeadingLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: 316, height: 49)
        self.backgroundColor = .white
        self.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.font = UIFont(name: "Baloo2-Bold", size: 28)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
