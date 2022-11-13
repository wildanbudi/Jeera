//
 //  MapsHelper.swift
 //  Jeera
 //
 //  Created by Anggi Dastariana on 24/10/22.
 //

 import Foundation
 import MapboxMaps

 public class CameraLocationConsumer: LocationConsumer {
     weak var mapView: MapView?

     init(mapView: MapView) {
         self.mapView = mapView
     }

     public func locationUpdate(newLocation: Location) {
//         
     }
 }
