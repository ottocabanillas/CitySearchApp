//
//  MapViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import CoreLocation

final class MapViewModel {
    // MARK: - Properties
    private let city: CityModel
    
    // MARK: - Computed Properties
    var markLabel: String {
        return city.name
    }
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: city.coordinates.lat,
            longitude: city.coordinates.lon
        )
    }
    // MARK: - Initialization
    init(city: CityModel) {
        self.city = city
    }
}
