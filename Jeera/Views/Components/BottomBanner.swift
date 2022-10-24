//
//  BottomBanner.swift
//  Jeera
//
//  Created by Wildan Budi on 23/10/22.
//

import UIKit

class BottomBanner: UIView {
    
    lazy var contentView = UIView()
//    lazy var etaLabel = UILabel()
    lazy var progressBar = UIProgressView()
//    lazy var cancelButton = UIButton()
    
    var progress: Float {
    get {
    return progressBar.progress
    }
    set {
    progressBar.setProgress(7, animated: false)
    }
    }
     
    var eta: String? {
    get {
    return etaLabel.text
    }
    set {
    etaLabel.text = "7"
    }
    }
    
//    weak var delegate: CustomBottomBannerViewDelegate?
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 316, height: 49)
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Baloo2-Bold", size: 28)
        view.text = "Angsa"
        return view
    }()
    
    private let etaLabel: UILabel = {
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 316, height: 49)
        view.backgroundColor = .white
        view.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "Baloo2-Bold", size: 20)
        view.text = "7 menit"
        return view
    }()
    
    private let cancelButton:UIButton = {
    let btn = UIButton(type: .system)
//        btn.configuration = .filled()
//        btn.configuration?.title = "Cancel"
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.PrimaryGreen
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.setTitle("Akhiri Rute", for: .normal)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addAction(UIAction { action in
    print("tapped")
    }, for: .touchUpInside)
    return btn
    }()
    
    init() {
           super.init(frame: .zero)
           
//        addSubview(contentView)
//        contentView.frame = bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        progressBar.progressTintColor = .systemGreen
//        progressBar.layer.borderColor = UIColor.black.cgColor
//        progressBar.layer.borderWidth = 2
//        progressBar.layer.cornerRadius = 5
//
//        cancelButton.backgroundColor = .systemGray
//        cancelButton.layer.cornerRadius = 5
//        cancelButton.setTitleColor(.darkGray, for: .highlighted)
//        etaLabel.text = "adasdasda"
         
        backgroundColor = .white
        layer.cornerRadius = 10
//        self.addSubview(titleLabel)
//        self.addSubview(etaLabel)
//        self.addSubview(cancelButton)
           addSubviews()
           setUpViews()
           setUpConstraints()
           
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       private func addSubviews() {
           [titleLabel, etaLabel, cancelButton]
               .forEach {
                   addSubview($0)
                   $0.translatesAutoresizingMaskIntoConstraints = false
               }
       }
       
       private func setUpViews() {
           
       }
       
       private func setUpConstraints() {
           let safeArea = safeAreaLayoutGuide
           
           titleLabel.anchor(
            top: self.safeAreaLayoutGuide.topAnchor,
            bottom: etaLabel.topAnchor,
            left: self.leftAnchor,
            right: self.rightAnchor,
            paddingTop: 20,
            paddingBottom: 10,
            paddingLeft: 20,
            paddingRight: 50
           )
           
           etaLabel.anchor(
            top: titleLabel.bottomAnchor,
            left: self.leftAnchor,
            right: self.rightAnchor,
            paddingLeft: 20,
            paddingRight: 50
           )
           
           cancelButton.anchor(
            top: etaLabel.bottomAnchor,
            left: self.leftAnchor,
            right: self.rightAnchor,
            paddingTop: 20,
            paddingLeft: 20,
            paddingRight: 20
           )
       }

}

import SwiftUI

@available(iOS 13, *)
struct BottomBannerPreview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            BottomBanner().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
