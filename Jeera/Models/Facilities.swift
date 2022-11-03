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

//protocol Facilities: Equatable, Hashable, Encodable, Decodable {
//    var idName: String { get set }
//    var enName: String { get set }
//    var type: String { get set }
//    var clusterName: String { get set }
//    var lat: Double { get set }
//    var long: Double { get set }
//}
