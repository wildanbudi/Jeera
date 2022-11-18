//
//  FacilitiesTableViewCell.swift
//  Jeera
//
//  Created by Anggi Dastariana on 07/11/22.
//

import UIKit

class FacilitiesTableViewCell: UITableViewCell {
    static let identifier = "FacilitiesTableViewCell"
    var cellName: String? {
        get { profileLabel.text }
        set {
            if newValue == "Piknik" {
                profileLabel.text = "Area Piknik"
            } else {
                profileLabel.text = newValue
            }
            iconImageView.image = UIImage(named: "\(newValue!) Outline")
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Baloo2-Medium", size: 17)
        label.textColor = .PrimaryText
        
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.left")?.imageWithColor(newColor: .ArrowProfile)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(iconImageView)
        contentView.addSubview(profileLabel)
        contentView.addSubview(arrowImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.anchor(
            left: contentView.leftAnchor,
            paddingLeft: 28,
            width: contentView.bounds.height * (30/58),
            height: contentView.bounds.height * (30/58)
        )
        iconImageView.centerY(inView: contentView)

        profileLabel.anchor(
            left: iconImageView.rightAnchor,
            paddingLeft: 20,
            width: contentView.bounds.height * (160/58),
            height: contentView.bounds.height * (30/58)
        )
        profileLabel.centerY(inView: contentView)

        arrowImageView.anchor(
            right: contentView.rightAnchor,
            paddingRight: 36,
            width: contentView.bounds.height * (20/58),
            height: contentView.bounds.height * (20/58)
        )
        arrowImageView.centerY(inView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
