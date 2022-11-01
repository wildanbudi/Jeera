//
//  UIButtonExtension.swift
//  Jeera
//
//  Created by Anggi Dastariana on 01/11/22.
//

import Foundation
import UIKit

extension UIButton{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: -0.25) // The bigger the number, the further it rotate
        rotation.duration = 3 // The bigger the number, the slower it rotate
        rotation.isCumulative = false // False: The rotation wont continue
        rotation.autoreverses = true // True: The image will go back where it belongs
        rotation.repeatCount = Float.greatestFiniteMagnitude // Never ending animation (until the user turn on the location permission)
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
