//
//  EndOfRouteViewController.swift
//  Jeera
//
//  Created by Wildan Budi on 18/11/22.
//

import UIKit

class EndOfRouteViewController: UIViewController, EndOfRouteViewDelegate {
    
    var animalName: String?
    
    lazy var endRouteView: EndOfRouteView = {
        let view = EndOfRouteView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.animalImage.image = UIImage(named: "\(animalName!) Icon")
        view.animalLabel.text = animalName
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(endRouteView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            endRouteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            endRouteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            endRouteView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
        self.modalPresentationStyle = .popover
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func endRoute(_ banner: EndOfRouteView) {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct EndOfRouteViewController_Preview: PreviewProvider {
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            EndOfRouteViewController().showPreview().previewInterfaceOrientation(.portrait)
        }
    }
}
#endif
