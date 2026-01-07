//
//  MapViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import CoreLocation

final class MapViewModel {
    let city: CityModel
    
    var markLabel: String {
        return city.name
    }
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: city.coordinates.lat,
            longitude: city.coordinates.lon
        )
    }
    
    init(city: CityModel) {
        self.city = city
    }
}
