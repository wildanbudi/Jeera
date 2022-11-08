//
//  RecommendationsTableViewCell.swift
//  Jeera
//
//  Created by Anggi Dastariana on 07/11/22.
//

import UIKit

class RecommendationsTableViewCell: UITableViewCell {
    static let identifier = "RecommendationsTableViewCell"
    var cellName: String? {
        get { profileLabel.text }
        set {
            profileImageView.image = UIImage(named: newValue!)
            profileLabel.text = newValue
        }
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Baloo2-SemiBold", size: 22)
        label.textColor = .PrimaryText
        
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.left")?.imageWithColor(newColor: .ArrowProfile)
        
        return imageView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .PrimaryGreen
        view.layer.cornerRadius = 20
        view.addSubview(profileImageView)
        view.addSubview(profileLabel)
        view.addSubview(arrowImageView)
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.anchor(
            width: contentView.bounds.width * (358/390),
            height: contentView.bounds.height * (65/85)
        )
        containerView.center(inView: contentView)
        
        profileImageView.anchor(
            left: containerView.leftAnchor,
            paddingLeft: 16,
            width: contentView.bounds.height * (65/85),
            height: contentView.bounds.height * (65/85)
        )
        profileImageView.centerY(inView: containerView)

        profileLabel.anchor(
            left: profileImageView.rightAnchor,
            paddingLeft: 28,
            width: contentView.bounds.height * (165/85),
            height: contentView.bounds.height * (30/85)
        )
        profileLabel.centerY(inView: containerView)

        arrowImageView.anchor(
            right: containerView.rightAnchor,
            paddingRight: 28,
            width: contentView.bounds.height * (20/85),
            height: contentView.bounds.height * (20/85)
        )
        arrowImageView.centerY(inView: containerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
