//
//  CityCellViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

final class CityCellViewModel {
    let city: CityModel
    
    var titleLabel: String {
        return "\(city.name), \(city.countryCode)"
    }
    
    var subtitleLabel: String {
        return "Lat: \(city.coordinates.lat), Lon: \(city.coordinates.lon)"
    }
    
    var isFavorite: Bool {
        if let favorite = city.isFavorite {
            return favorite
        }
        return false
    }
    
    init(city: CityModel) {
        self.city = city
    }
}
