//
//  ClusterName.swift
//  Jeera
//
//  Created by Anggi Dastariana on 06/11/22.
//

import Foundation

func getClusterName(idName: String) -> String {
    switch idName {
    case "Terarium Reptil 1", "Terarium Reptil 2":
        return "Terarium Reptil"
    case "Primata 1", "Primata 2", "Primata 3", "Primata 4":
        return "Primata"
    case "Unggas 1", "Unggas 2":
        return "Unggas"
    case "Harimau Sumatera":
        return "Harimau"
    case "Singa Afrika":
        return "Singa"
    case "Orangutan Kalimantan", "Orangutan Sumatera":
        return "Orangutan"
    case "Beruang Madu", "Beruang Hitam Amerika":
        return "Beruang"
    default:
        return idName
    }
}
