//
//  AllDataTypes.swift
//  Jeera
//
//  Created by Anggi Dastariana on 03/11/22.
//

import Foundation
import Turf

//protocol AllData {}
//
//extension Animals: AllData {}
//extension Facilities: AllData {}
//extension Cages: AllData {}

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
    
//    init(cage: String? = "", idName: String, enName: String, latinName: String? = "", type: String, clusterName: String? = "", lat: Double, long: Double) {
//        self.cage = cage
//        self.idName = idName
//        self.enName = enName
//        self.latinName = latinName
//        self.type = type
//        self.clusterName = clusterName
//        self.lat = lat
//        self.long = long
//    }
}

