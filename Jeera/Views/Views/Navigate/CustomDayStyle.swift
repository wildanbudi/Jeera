//
//  CustomDay.swift
//  Jeera
//
//  Created by Wildan Budi on 21/10/22.
//

import UIKit
import MapboxNavigation

class CustomDayStyle: DayStyle {
    
    private let backgroundColor = #colorLiteral(red: 0.06276176125, green: 0.6164312959, blue: 0.3432356119, alpha: 1)
    private let darkBackgroundColor = #colorLiteral(red: 0.0473754704, green: 0.4980872273, blue: 0.2575169504, alpha: 1)
    private let secondaryBackgroundColor = #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
    private let blueColor = #colorLiteral(red: 0.26683864, green: 0.5903761983, blue: 1, alpha: 1)
    private let lightGrayColor = #colorLiteral(red: 0.5294117647, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
    private let darkGrayColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    private let primaryLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    private let secondaryLabelColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9)
    
    required init() {
        super.init()
        mapStyleURL = URL(string: mapAllDisableStyleURI)!
        styleType = .day
    }
    
    override func apply() {
        super.apply()
        
        let traitCollection = UIScreen.main.traitCollection
        
        InstructionsBannerView.appearance(for: traitCollection).backgroundColor = .white
        
        PrimaryLabel.appearance(for: traitCollection, whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = .black
        PrimaryLabel.appearance(for: traitCollection, whenContainedInInstancesOf: [InstructionsBannerView.self]).font = UIFont(name: "Baloo2-Bold", size: 30)
        
        DistanceLabel.appearance(for: traitCollection, whenContainedInInstancesOf: [InstructionsBannerView.self]).unitTextColor = lightGrayColor
        DistanceLabel.appearance(for: traitCollection, whenContainedInInstancesOf: [InstructionsBannerView.self]).valueTextColor = lightGrayColor
        
        ManeuverView.appearance(for: traitCollection, whenContainedInInstancesOf: [InstructionsBannerView.self]).primaryColor = .PrimaryGreen
        
        NavigationMapView.appearance(for: traitCollection).routeCasingColor = .SecondaryGreen
        NavigationMapView.appearance(for: traitCollection).trafficLowColor = .PrimaryGreen
        NavigationMapView.appearance(for: traitCollection).trafficUnknownColor = .PrimaryGreen
        
//        ArrivalTimeLabel.appearance(for: traitCollection).textColor = lightGrayColor
//        BottomBannerView.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
//        BottomPaddingView.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
//        Button.appearance(for: traitCollection).textColor = #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
//        CancelButton.appearance(for: traitCollection).tintColor = lightGrayColor
//        
//        DistanceRemainingLabel.appearance(for: traitCollection).textColor = lightGrayColor
//        DismissButton.appearance(for: traitCollection).textColor = darkGrayColor
//        FloatingButton.appearance(for: traitCollection).backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
//        FloatingButton.appearance(for: traitCollection).tintColor = blueColor
//        TopBannerView.appearance(for: traitCollection).backgroundColor = backgroundColor
//        
//        LanesView.appearance(for: traitCollection).backgroundColor = darkBackgroundColor
//        LaneView.appearance(for: traitCollection).primaryColor = #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
//        ManeuverView.appearance(for: traitCollection).backgroundColor = backgroundColor
//        
//        ManeuverView.appearance(for: traitCollection, whenContainedInInstancesOf: [InstructionsBannerView.self]).secondaryColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
//        ManeuverView.appearance(for: traitCollection, whenContainedInInstancesOf: [NextBannerView.self]).primaryColor = #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
//        ManeuverView.appearance(for: traitCollection, whenContainedInInstancesOf: [NextBannerView.self]).secondaryColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
//        ManeuverView.appearance(for: traitCollection, whenContainedInInstancesOf: [StepInstructionsView.self]).primaryColor = darkGrayColor
//        ManeuverView.appearance(for: traitCollection, whenContainedInInstancesOf: [StepInstructionsView.self]).secondaryColor = lightGrayColor
//        NextBannerView.appearance(for: traitCollection).backgroundColor = backgroundColor
//        NextInstructionLabel.appearance(for: traitCollection).textColor = #colorLiteral(red: 0.9842069745, green: 0.9843751788, blue: 0.9841964841, alpha: 1)
//        NavigationMapView.appearance(for: traitCollection).tintColor = blueColor
//       
//        NavigationMapView.appearance(for: traitCollection).trafficHeavyColor = #colorLiteral(red: 0.9995597005, green: 0, blue: 0, alpha: 1)
//        NavigationMapView.appearance(for: traitCollection).trafficLowColor = blueColor
//        NavigationMapView.appearance(for: traitCollection).trafficModerateColor = #colorLiteral(red: 1, green: 0.6184511781, blue: 0, alpha: 1)
//        NavigationMapView.appearance(for: traitCollection).trafficSevereColor = #colorLiteral(red: 0.7458544374, green: 0.0006075350102, blue: 0, alpha: 1)
//        
//        // Customize the color that appears on the traversed section of a route
//        NavigationMapView.appearance(for: traitCollection).traversedRouteColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
//        
//        PrimaryLabel.appearance(for: traitCollection, whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = darkGrayColor
//        ResumeButton.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
//        ResumeButton.appearance(for: traitCollection).tintColor = blueColor
//        SecondaryLabel.appearance(for: traitCollection, whenContainedInInstancesOf: [InstructionsBannerView.self]).normalTextColor = secondaryLabelColor
//        SecondaryLabel.appearance(for: traitCollection, whenContainedInInstancesOf: [StepInstructionsView.self]).normalTextColor = darkGrayColor
//        TimeRemainingLabel.appearance(for: traitCollection).textColor = lightGrayColor
//        TimeRemainingLabel.appearance(for: traitCollection).trafficLowColor = darkBackgroundColor
//        TimeRemainingLabel.appearance(for: traitCollection).trafficUnknownColor = darkGrayColor
//        WayNameLabel.appearance(for: traitCollection).normalTextColor = blueColor
//        WayNameView.appearance(for: traitCollection).backgroundColor = secondaryBackgroundColor
    }
}
