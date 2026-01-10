//
//  CityCellViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

final class CityCellViewModel {
    //MARK: - Properties
    private let city: CityModel
    
    //MARK: - Computed Properties
    var titleLabel: String {
        return "\(city.name), \(city.countryCode)"
    }
    
    var subtitleLabel: String {
        return "Lat: \(city.coordinates.lat), Lon: \(city.coordinates.lon)"
    }
    
    var isFavorite: Bool {
        return city.isFavorite
//        if let favorite = city.isFavorite {
//            return favorite
//        }
//        return false
    }
    
    //MARK: - Initialization
    init(city: CityModel) {
        self.city = city
    }
}
