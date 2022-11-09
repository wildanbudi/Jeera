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
        didSet {
            profileImageView.image = UIImage(named: "\(cellName!) Rekomendasi")
        }
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.addSubview(profileImageView)
        
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
        
        profileImageView.anchor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
