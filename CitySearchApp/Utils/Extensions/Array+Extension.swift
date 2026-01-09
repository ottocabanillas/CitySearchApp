//
//  Array+Extension.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 09/01/2026.
//

extension Array where Element == CityModel {
    func binarySearchIndex(_ targetCity: CityModel) -> Int? {
        var low = 0
        var high = count - 1

        while low <= high {
            let mid = low + (high - low) / 2
            let midName = self[mid].name
            let midCountry = self[mid].countryCode

            if (midName, midCountry) == (targetCity.name, targetCity.countryCode) {
                return mid
            } else if (midName, midCountry) < (targetCity.name, targetCity.countryCode) {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        return nil
    }
}
