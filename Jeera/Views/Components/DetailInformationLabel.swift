//
//  DetailInformationLabel.swift
//  Jeera
//
//  Created by Anggi Dastariana on 06/11/22.
//

import Foundation
import UIKit

func labelWithIcon(imageName: String, labelText: String, iconColor: UIColor?) -> UILabel {
    let label = UILabel(frame: .zero)
    let iconLabel = NSTextAttachment()
    iconLabel.image = UIImage(named: imageName)
    let imageOffsetY: CGFloat = -1.0
    iconLabel.bounds = CGRect(x: 0, y: imageOffsetY, width: iconLabel.image!.size.width, height: iconLabel.image!.size.height)
    let attachmentString = NSAttributedString(attachment: iconLabel)
    let completeText = NSMutableAttributedString(string: "")
    completeText.append(attachmentString)
    let textAfterIcon = NSAttributedString(string: "  \(labelText)")
    completeText.append(textAfterIcon)
    label.textAlignment = .center
    label.attributedText = completeText
    label.textColor = .PrimaryText
        
    return label
}
