//
//  GeoJSON.swift
//  Jeera
//
//  Created by Anggi Dastariana on 21/11/22.
//

import Foundation

// MARK: - Create a Model that represents whatever the structure of the "RagunanZooAnimals" JSON File (Array of Objects)
// RagunanZooAnimals JSON
struct AnimalsJSONResult: Codable {
    let features: [AnimalsJSONResultItem]
    let type: String
}

// RagunanZooAnimals Feature
struct AnimalsJSONResultItem: Codable {
    let type: String
    let properties: AnimalsProperties
    let geometry: Geometry1
    let id: String
}

// RagunanZooAnimals Properties
struct AnimalsProperties: Codable {
    let enName, idName, latinName: String
    let cage: String
}


// MARK: - Create a Model that represents whatever the structure of the "RagunanZooCages" JSON File (Array of Objects)
// RagunanZooCages JSON
struct CagesJSONResult: Codable {
    let features: [CagesJSONResultItem]
    let type: String
}

// RagunanZooCages Feature
struct CagesJSONResultItem: Codable {
    let type: String
    let properties: CagesProperties
    let geometry: Geometry1
    let id: String
}

// RagunanZooCages Properties
struct CagesProperties: Codable {
    let idName, enName: String
    let type: String
    let clusterName: String
}

// Geometry
struct Geometry1: Codable {
    let coordinates: [Double]
    let type: String
}
