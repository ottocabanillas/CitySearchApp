//
//  CityBinarySearch.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 08/01/2026.
//

import Foundation

protocol SearchStrategy {
    func search(prefix: String, source: [CityModel]) -> [CityModel]
}

final class CityBinarySearch: SearchStrategy {
    func search(prefix: String, source: [CityModel]) -> [CityModel] {
        let target = prefix.normalizedForSearch()
        guard !target.isEmpty, !source.isEmpty else { return [] }

        let pairs = source.map { (key: "\($0.name), \($0.countryCode)".normalizedForSearch(), city: $0) }
        let sortedPairs = pairs.sorted { $0.key < $1.key }
        let cities = sortedPairs.map { $0.city }
        let normalizedKeys = sortedPairs.map { $0.key }

        let start = lowerBound(of: target, in: normalizedKeys)
        let end = upperBound(of: target, in: normalizedKeys)

        return Array(cities[start..<end])
    }

    private func lowerBound(of target: String, in keys: [String]) -> Int {
        var low = 0, high = keys.count
        while low < high {
            let mid = (low + high) / 2
            if keys[mid] < target {
                low = mid + 1
            } else {
                high = mid
            }
        }
        return low
    }

    private func upperBound(of target: String, in keys: [String]) -> Int {
        let targetUpper = target + "\u{FFFF}"
        var low = 0, high = keys.count
        while low < high {
            let mid = (low + high) / 2
            if keys[mid] <= targetUpper {
                low = mid + 1
            } else {
                high = mid
            }
        }
        return low
    }
}

extension String {
    func normalizedForSearch() -> String {
        self.folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
}
