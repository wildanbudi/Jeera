//
//  CustomNightStyle.swift
//  Jeera
//
//  Created by Wildan Budi on 21/10/22.
//

import UIKit
import MapboxNavigation

class CustomNightStyle: NightStyle {
    
    private let backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    private let darkBackgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    private let secondaryBackgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    private let blueColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    private let lightGrayColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    private let darkGrayColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    private let primaryTextColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    private let secondaryTextColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    
    required init() {
        super.init()
//        mapStyleURL = URL(string: "mapbox://styles/mapbox/satellite-streets-v9")!
        styleType = .night
    }
    
    override func apply() {
        super.apply()
        
        let traitCollection = UIScreen.main.traitCollection
        DistanceRemainingLabel.appearance(for: traitCollection).normalTextColor = primaryTextColor
        BottomBannerView.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
        BottomPaddingView.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
        FloatingButton.appearance(for: traitCollection).backgroundColor = #colorLiteral(red: 0.1434620917, green: 0.1434366405, blue: 0.1819391251, alpha: 0.9037466989)
        TimeRemainingLabel.appearance(for: traitCollection).textColor = primaryTextColor
        TimeRemainingLabel.appearance(for: traitCollection).trafficLowColor = primaryTextColor
        TimeRemainingLabel.appearance(for: traitCollection).trafficUnknownColor = primaryTextColor
        ResumeButton.appearance(for: traitCollection).backgroundColor = #colorLiteral(red: 0.1434620917, green: 0.1434366405, blue: 0.1819391251, alpha: 0.9037466989)
        ResumeButton.appearance(for: traitCollection).tintColor = blueColor
    }
}
