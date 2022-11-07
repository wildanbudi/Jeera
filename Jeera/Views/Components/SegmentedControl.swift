//
//  SegmentedControl.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import Foundation
import UIKit

class SegmentedControl {
    static var whiteBackground: UIView = {
        let view = UIView(frame: .zero)
        view.layer.backgroundColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    static var segmentedBase: UIView = {
        let view = UIView(frame: CGRectMake(10, 80, 355, 32))
        view.layer.cornerRadius = 355/2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    static var segmentedButtons: [UIButton] = {
        var buttons = [UIButton(type: .system)]
        buttons.removeAll()
        for title in segmentedTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.SecondaryText, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            buttons.append(button)
        }
        buttons[0].setTitleColor(.white, for: .normal)
        buttons[0].titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        return buttons
    }()
    
    static var segmentedSelector: UIView = {
        let selectorWidth = segmentedBase.frame.width / CGFloat(segmentedTitles.count)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: segmentedBase.frame.height))
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = .PrimaryGreen
        
        return view
    }()
    
    static var segmentedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
}
