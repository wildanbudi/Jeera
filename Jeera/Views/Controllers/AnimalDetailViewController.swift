//
//  AnimalDetailViewController.swift
//  Jeera
//
//  Created by Anggi Dastariana on 27/10/22.
//

import UIKit
import MapboxMaps
import MapboxDirections

class AnimalDetailViewController: UIViewController {
    var animalData: Dictionary<String, JSONValue>!
    var targetCoordinate: CLLocationCoordinate2D!
    var distance: Int!
    var travelTime: Int!
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.left.circle")?
            .resizeImageTo(size: CGSize(width: 30, height: 30))?
            .imageWithColor(newColor: .PrimaryGreen), for: .normal)

        button.addTarget(self, action: #selector(self.backButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var animalImage: UIImageView = {
        let type = animalData["type"]!.rawValue as? String
        let imageName = animalData[(type == "Kandang" ? "idName" : "clusterName")]!.rawValue as? String
        let imageView = UIImageView(image: UIImage(named: imageName!))
        imageView.frame = .zero
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var animalNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont(name: "Baloo2-Bold", size: 30)
        label.numberOfLines = 2
        label.text = animalData["idName"]!.rawValue as? String
        label.textColor = .PrimaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        return labelWithIcon(imageName: "Distance", labelText: "\(distance ?? 0) meter", iconColor: .PrimaryGreen)
    }()
    
    lazy var etaLabel: UILabel = {
        return labelWithIcon(imageName: "Time", labelText: "\(travelTime ?? 0) menit", iconColor: .PrimaryGreen)
    }()
    
    lazy var cageLabel: UILabel = {
        return labelWithIcon(imageName: "Location", labelText: "Primata 1", iconColor: .PrimaryGreen)
    }()
    
    lazy var informationView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.fill
        stackView.spacing = 20.0

        stackView.addArrangedSubview(distanceLabel)
        stackView.addArrangedSubview(etaLabel)
        if animalData["type"]!.rawValue as? String != "Kandang" {
            stackView.addArrangedSubview(cageLabel)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var startJourneyButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Mulai Perjalanan"
        config.baseBackgroundColor = .PrimaryGreen
        config.baseForegroundColor = .white
        config.titleTextAttributesTransformer =
          UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            return outgoing
          }
        
        button.configuration = config
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var overviewMapView: MapView = {
        let options = MapInitOptions(cameraOptions: CameraOptions(center: targetCoordinate, zoom: 16.5), styleURI: StyleURI(rawValue: inactiveStyleURI))
        let mapView = MapView(frame: .zero, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.layer.cornerRadius = 20
        mapView.clipsToBounds = true
        
        let clusterName = animalData["clusterName"]!.rawValue as? String
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        var customPointAnnotation = PointAnnotation(coordinate: targetCoordinate)
        customPointAnnotation.image = .init(image: UIImage(named: "\(clusterName!) Active")!, name: "\(clusterName!) Active")
        pointAnnotationManager.annotations = [customPointAnnotation]
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        return mapView
    }()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        getRouteInformation()
    }
    
    @objc func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.UpperGradient.cgColor, UIColor.LowerGradient.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        [backButton, animalImage, animalNameLabel, startJourneyButton, overviewMapView, informationView].forEach {
            view.addSubview($0)
        }
        setupConstraint()
    }
    
    func setupConstraint() {
        let safeArea = view.layoutMarginsGuide
        
        backButton.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            paddingTop: 47,
            paddingLeft: 16,
            width: view.bounds.height * (30 / 844),
            height: view.bounds.height * (30 / 844)
        )
        
        animalImage.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            height: view.bounds.height * (390 / 844)
        )
        
        startJourneyButton.anchor(
            bottom: safeArea.bottomAnchor,
            left: view.leftAnchor,
            paddingBottom: 14,
            paddingLeft: 16,
            height: view.bounds.height * (50 / 844)
        )
        
        startJourneyButton.centerX(inView: view)
        
        overviewMapView.anchor(
            bottom: startJourneyButton.topAnchor,
            left: view.leftAnchor,
            paddingBottom: 20,
            paddingLeft: 16,
            height: view.bounds.height * (214 / 844)
        )
        
        overviewMapView.centerX(inView: view)
        
        informationView.anchor(
            bottom: overviewMapView.topAnchor,
            left: view.leftAnchor,
            paddingBottom: 20,
            paddingLeft: 16
        )
        
        animalNameLabel.anchor(
            bottom: informationView.topAnchor,
            left: view.leftAnchor,
            paddingBottom: 5,
            paddingLeft: 16,
            width: view.bounds.height * (332 / 844),
            height: view.bounds.height * (48 / 844)
        )
    }
    
    func getRouteInformation() {
        let directions = Directions.shared
        let waypoints = [
            Waypoint(coordinate: centerCoordinate, name: "origin"),
            Waypoint(coordinate: targetCoordinate, name: "destination"),
        ]
        let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)
        let task = directions.calculate(options) { (session, result) in
            switch result {
            case .failure(let error):
                print("Error calculating directions: \(error)")
            case .success(let response):
                guard let route = response.routes?.first, let _ = route.legs.first else {
                    return
                }
                
                self.distance = Int(route.distance)
                self.travelTime = Int(route.expectedTravelTime/60) + 1
                
                self.setupView()
//
//                print("Route via \(leg):")
//
//                let distanceFormatter = LengthFormatter()
//                let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
//
//                let travelTimeFormatter = DateComponentsFormatter()
//                travelTimeFormatter.unitsStyle = .short
//                let formattedTravelTime = travelTimeFormatter.string(from: route.expectedTravelTime)
//
                print("Distance: \(route.distance); ETA: \(route.expectedTravelTime)")
//                print(Int(route.expectedTravelTime/60))
//
//                for step in leg.steps {
//                    print("\(step.instructions)")
//                    let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
//                    print("— \(formattedDistance) —")
//                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


import SwiftUI

struct AnimalDetailViewControllerPreviews: PreviewProvider {
    static var previews: some View {
        UIAnimalDetailViewControllerPreview {
            return AnimalDetailViewController()
        }
        .previewDevice("iPhone 13")
    }
}

@available(iOS 13, *)
struct UIAnimalDetailViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    func makeUIViewController(context: Context) -> ViewController { viewController }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
    
    
}
