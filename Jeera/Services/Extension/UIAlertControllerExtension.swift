//
//  UIAlertControllerExtension.swift
//  Jeera
//
//  Created by Anggi Dastariana on 16/11/22.
//

import UIKit

extension UIAlertController {
    static func outsideArea() -> UIAlertController {
        let alert = UIAlertController(title: "Yah! Lokasi di luar jangkauan", message: "Sayang sekali, petunjuk arah tidak bisa digunakan karena berada diluar Ragunan", preferredStyle: .alert)
        alert.view.tintColor = .PrimaryGreen
        alert.addAction(UIAlertAction(title: "Oke!", style: .default))
        
        return alert
    }
}
