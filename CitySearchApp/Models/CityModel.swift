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
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case countryCode = "country_code"
        case coordinates = "coord"
    }
    
    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.countryCode == rhs.countryCode &&
        lhs.coordinates == rhs.coordinates &&
        lhs.isFavorite == rhs.isFavorite
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(countryCode)
        hasher.combine(coordinates)
        hasher.combine(isFavorite)
    }
}

struct Coordinates: Codable, Equatable, Hashable {
    let lat: Double
    let lon: Double
}
