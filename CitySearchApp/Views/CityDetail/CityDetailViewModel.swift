//
//  CityDetailViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation

final class CityDetailViewModel {
    let city: CityModel
    
    var titleLabel: String {
        let cityName = city.name
        let locale = Locale(identifier: "en_US")
        let countryName = locale.localizedString(forRegionCode: city.countryCode) ?? city.countryCode
        return "\(cityName), \(countryName)"
    }
    
    init(city: CityModel) {
        self.city = city
    }
}
