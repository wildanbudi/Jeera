//
//  SearchResultTableViewCell.swift
//  Jeera
//
//  Created by Anggi Dastariana on 05/11/22.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultTableViewCell"
    var cellName: String? {
        get { profileLabel.text }
        set {
            profileImageView.image = UIImage(named: "\(newValue!) Icon")
            profileLabel.text = newValue
        }
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Baloo2-Regular", size: 17)
        
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "arrow.up.left")?.imageWithColor(newColor: .ArrowProfile)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.anchor(
            left: contentView.leftAnchor,
            paddingLeft: 16,
            width: contentView.bounds.height * (60/112),
            height: contentView.bounds.height * (60/112)
        )
        profileImageView.centerY(inView: contentView)
        
        profileLabel.anchor(
            left: profileImageView.rightAnchor,
            paddingLeft: 20,
            width: contentView.bounds.height * (170/112),
            height: contentView.bounds.height * (60/112)
        )
        profileLabel.centerY(inView: contentView)
        
        arrowImageView.anchor(
            right: contentView.rightAnchor,
            paddingRight: 16,
            width: contentView.bounds.height * (20/112),
            height: contentView.bounds.height * (20/112)
        )
        arrowImageView.centerY(inView: contentView)
    }
    
    func setupCellView() {
        contentView.addSubview(profileLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(arrowImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
