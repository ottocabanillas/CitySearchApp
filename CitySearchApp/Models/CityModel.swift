//
//  CityModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation

struct CityModel: Codable, Identifiable {
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
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}
