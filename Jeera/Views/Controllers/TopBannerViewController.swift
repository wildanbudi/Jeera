//
//  TopBannerViewController.swift
//  Jeera
//
//  Created by Wildan Budi on 02/11/22.
//

import UIKit
import CoreLocation
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class TopBannerViewController: ContainerViewController {
    
    private lazy var instructionsBannerTopOffsetConstraint = {
        return instructionsBannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
    }()
    private lazy var centerOffset: CGFloat = calculateCenterOffset(with: view.bounds.size)
    private lazy var instructionsBannerCenterOffsetConstraint = {
        return instructionsBannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
    }()
    private lazy var instructionsBannerWidthConstraint = {
        return instructionsBannerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
    }()
    
    // You can Include one of the existing Views to display route-specific info
    lazy var instructionsBannerView: InstructionsBannerView = {
        let banner = InstructionsBannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.heightAnchor.constraint(equalToConstant: 87.0).isActive = true
        banner.layer.cornerRadius = 45
        banner.separatorView.isHidden = true
        
        banner.distanceLabel.leadingAnchor.constraint(equalTo: banner.dividerView.trailingAnchor).isActive = true
        banner.distanceLabel.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -18).isActive = true
        banner.distanceLabel.topAnchor.constraint(equalTo: banner.centerYAnchor, constant: 6).isActive = true
        banner.distanceLabel.bottomAnchor.constraint(equalTo: banner.maneuverView.bottomAnchor, constant: 0).isActive = true
        banner.distanceLabel.centerXAnchor.constraint(equalTo: banner.primaryLabel.centerXAnchor, constant: 0).isActive = true
        banner.distanceLabel.centerYAnchor.constraint(equalTo: banner.centerYAnchor, constant: 16).isActive = true

        banner.primaryLabel.topAnchor.constraint(equalTo: banner.topAnchor, constant: 0).isActive = true
        banner.primaryLabel.centerYAnchor.constraint(equalTo: banner.centerYAnchor, constant: -16).isActive = true
        
        banner.maneuverView.centerYAnchor.constraint(equalTo: banner.centerYAnchor).isActive = true
        return banner
    }()
    
    override func viewDidLoad() {
        //        super.viewDidLoad()
        view.addSubview(instructionsBannerView)
        // Do any additional setup after loading the view.
        setupConstraints()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateConstraints()
    }
    
    private func setupConstraints() {
        instructionsBannerCenterOffsetConstraint.isActive = true
        instructionsBannerTopOffsetConstraint.isActive = true
        instructionsBannerWidthConstraint.isActive = true
    }
    
    private func updateConstraints() {
        instructionsBannerCenterOffsetConstraint.constant = centerOffset
    }
    
    // MARK: - Device rotation
    
    private func calculateCenterOffset(with size: CGSize) -> CGFloat {
        return (size.height < size.width ? -size.width / 5 : 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        centerOffset = calculateCenterOffset(with: size)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateConstraints()
    }
    
    // MARK: - NavigationServiceDelegate implementation
    
    public func navigationService(_ service: NavigationService, didUpdate progress: RouteProgress, with location: CLLocation, rawLocation: CLLocation) {
        // pass updated data to sub-views which also implement `NavigationServiceDelegate`
        instructionsBannerView.updateDistance(for: progress.currentLegProgress.currentStepProgress)
    }
    
    public func navigationService(_ service: NavigationService, didPassVisualInstructionPoint instruction: VisualInstructionBanner, routeProgress: RouteProgress) {
        instructionsBannerView.update(for: instruction)
    }
    
    public func navigationService(_ service: NavigationService, didRerouteAlong route: Route, at location: CLLocation?, proactive: Bool) {
        instructionsBannerView.updateDistance(for: service.routeProgress.currentLegProgress.currentStepProgress)
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TopBannerViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            TopBannerViewController().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
#endif

