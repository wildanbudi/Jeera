//
//  AllDataTypes.swift
//  Jeera
//
//  Created by Anggi Dastariana on 03/11/22.
//

import Foundation
import Turf

struct AllData: Equatable, Hashable, Encodable, Decodable {
    var cage: String
    var idName: String
    var enName: String
    var latinName: String
    var type: String
    var clusterName: String
    var lat: Double
    var long: Double
    var distance: Int
    var travelTime: Int
    var dict: Dictionary<String, JSONValue>
    var isChecked: Bool? = false
}

