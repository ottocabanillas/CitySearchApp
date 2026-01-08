//
//  CityModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation

struct CityModel: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let countryCode: String
    let coordinates: Coordinates
    var isFavorite: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case countryCode = "country"
        case coordinates = "coord"
        case isFavorite = "isFavorite"
    }
    
    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        lhs.id == rhs.id 
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Coordinates: Codable, Equatable, Hashable {
    let lat: Double
    let lon: Double
}
