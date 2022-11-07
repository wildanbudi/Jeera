//
//  Animals.swift
//  Jeera
//
//  Created by Wildan Budi on 20/10/22.
//

import Foundation

struct Animals: Equatable, Hashable, Encodable, Decodable {
    var cage: String
    var idName: String
    var enName: String
    var latinName: String
    var type: String
    var lat: Double
    var long: Double
}

//protocol Animals: Equatable, Hashable, Encodable, Decodable {
//    var cage: String { get set }
//    var idName: String { get set }
//    var enName: String { get set }
//    var latinName: String { get set }
//    var type: String { get set }
//    var lat: Double { get set }
//    var long: Double { get set }
//}
