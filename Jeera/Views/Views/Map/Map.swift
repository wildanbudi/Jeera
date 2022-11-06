//
//  Map.swift
//  Jeera
//
//  Created by Anggi Dastariana on 03/11/22.
//

import UIKit
import Foundation
import MapboxMaps

class Map {
    var zoomLevel: CGFloat?
    var targetCoordinate: CLLocationCoordinate2D! = centerCoordinate
    
    lazy var mapView: MapView = {
        let styleURI = zoomLevel == 10 ? mapAllIconOverlap
                    : zoomLevel == 16 ? mapAllDefaultStyleURI
                    : mapAllDisableStyleURI
        var options = MapInitOptions(cameraOptions: CameraOptions(center: targetCoordinate, zoom: zoomLevel), styleURI: StyleURI(rawValue: styleURI))
        let view = MapView(frame: .zero, mapInitOptions: options)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.ornaments.options.scaleBar.visibility = .hidden
        view.ornaments.options.compass.visibility = .hidden
        
        return view
    }()
    
    func getMapView() -> MapView {
        if zoomLevel != 16 {
            mapView.gestures.options.panEnabled = false
            mapView.gestures.options.pinchEnabled = false
            mapView.gestures.options.pinchPanEnabled = false
            mapView.gestures.options.pinchZoomEnabled = false
            mapView.gestures.options.doubleTapToZoomInEnabled = false
            mapView.gestures.options.doubleTouchToZoomOutEnabled = false
            mapView.gestures.options.pitchEnabled = false
        }
        return mapView
    }
}

