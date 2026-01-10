//
//  CityModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation

struct CityModel: Codable, Identifiable {
    //MARK: - Properties
    let id: Int
    let name: String
    let countryCode: String
    let coordinates: Coordinates
    var isFavorite: Bool = false
    
    //MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case countryCode = "country"
        case coordinates = "coord"
    }
}

// MARK: - Equatable & Hashable
extension CityModel: Equatable, Hashable {
    static func == (lhs: CityModel, rhs: CityModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: -
struct Coordinates: Codable, Equatable, Hashable {
    let lat: Double
    let lon: Double
}
