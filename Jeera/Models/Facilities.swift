//
//  Facilities.swift
//  Jeera
//
//  Created by Anggi Dastariana on 02/11/22.
//

import Foundation

struct Facilities: Equatable, Hashable, Encodable, Decodable {
    var idName: String
    var enName: String
    var type: String
    var clusterName: String
    var lat: Double
    var long: Double
}