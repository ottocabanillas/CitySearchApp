//
//  CityListViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Combine

final class CityListViewModel: ObservableObject {
    @Published private(set) var allCities: [CityModel] = [
        CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false),
        CityModel(id: 2, name: "Chicago", countryCode: "US", coordinates: Coordinates(lat: 41.8781, lon: -87.6298), isFavorite: false),
        CityModel(id: 3, name: "Los Angeles", countryCode: "US", coordinates: Coordinates(lat: 34.0522, lon: -118.2437), isFavorite: false),
        CityModel(id: 5, name: "Phoenix", countryCode: "US", coordinates: Coordinates(lat: 33.4484, lon: -112.0740), isFavorite: false),
    ]
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    
    var displayedCities: [CityModel] {
        return allCities
    }
}
