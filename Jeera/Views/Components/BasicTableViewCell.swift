//
//  BasicTableViewCell.swift
//  Jeera
//
//  Created by Anggi Dastariana on 05/11/22.
//

import UIKit

class BasicTableViewCell: UITableViewCell {
    static let identifier = "BasicTableViewCell"
    var senderIdentifier: String!
    var cellName: String? {
        get { profileLabel.text }
        set {
            profileImageView.image = UIImage(named: "\(newValue!) Icon")
            profileLabel.text = newValue
        }
    }
    var isChecked: Bool! {
        didSet {
            if isChecked {
                checkBox.image = UIImage(systemName: "checkmark.circle.fill")?.imageWithColor(newColor: .PrimaryGreen)
            } else {
                checkBox.image = UIImage(systemName: "circle")?.imageWithColor(newColor: .black)
            }
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        if senderIdentifier == "RoutePlanTableViewCell" {
            view.addSubview(checkBox)
        }
        view.addSubview(profileImageView)
        view.addSubview(profileLabel)
        if senderIdentifier == BasicTableViewCell.identifier {
            view.addSubview(arrowImageView)
        }
        
        return view
    }()
    
    lazy var checkBox: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle")?.imageWithColor(newColor: .black)
        
        return imageView
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Baloo2-Regular", size: 17)
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
        senderIdentifier = reuseIdentifier
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if senderIdentifier == "RoutePlanTableViewCell" && selected {
            isChecked.toggle()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let isRoutePlanTableViewCell = senderIdentifier == "RoutePlanTableViewCell"
        containerView.anchor(
            width: contentView.bounds.width * (358/390),
            height: contentView.bounds.height * (92/112)
        )
        containerView.center(inView: contentView)
        
        if isRoutePlanTableViewCell {
            checkBox.anchor(
                left: containerView.leftAnchor,
                paddingLeft: 16,
                width: contentView.bounds.height * (24/112),
                height: contentView.bounds.height * (24/112)
            )
            checkBox.centerY(inView: containerView)
        }
        
        profileImageView.anchor(
            left: isRoutePlanTableViewCell ? checkBox.rightAnchor : containerView.leftAnchor,
            paddingLeft: isRoutePlanTableViewCell ? 20 : 16,
            width: contentView.bounds.height * (60/112),
            height: contentView.bounds.height * (60/112)
        )
        profileImageView.centerY(inView: containerView)

        profileLabel.anchor(
            left: profileImageView.rightAnchor,
            paddingLeft: 20,
            width: contentView.bounds.height * (200/112),
            height: contentView.bounds.height * (60/112)
        )
        profileLabel.centerY(inView: containerView)
        
        if senderIdentifier == BasicTableViewCell.identifier {
            arrowImageView.anchor(
                right: containerView.rightAnchor,
                paddingRight: 16,
                width: contentView.bounds.height * (20/112),
                height: contentView.bounds.height * (20/112)
            )
            arrowImageView.centerY(inView: containerView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
