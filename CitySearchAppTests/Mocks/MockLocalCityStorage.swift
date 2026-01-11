//
//  MockLocalCityStorage.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 10/01/2026.
//

import Foundation
@testable import CitySearchApp

final class MockLocalCityStorage: CityStorage {
    private var storage: Set<Int> = [2147714, 4829764]
    var shouldThrowErrorOnLoad = false
    var shouldThrowErrorOnSave = false
    
    func load<T: Decodable>(_ type: T.Type) throws -> T {
        if shouldThrowErrorOnLoad {
            throw NSError(domain: "MockLocalCityStorage", code: 1, userInfo: [NSLocalizedDescriptionKey: "Simulated load error"])
        }
        let data = try JSONEncoder().encode(storage)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func save<T: Encodable>(_ value: T) throws {
        if shouldThrowErrorOnSave {
            throw NSError(domain: "MockLocalCityStorage", code: 2, userInfo: [NSLocalizedDescriptionKey: "Simulated save error"])
        }

        let data = try JSONEncoder().encode(value)
        if let newSet = try? JSONDecoder().decode(Set<Int>.self, from: data) {
            storage = newSet
        }
    }
    
    func clear() {
        storage.removeAll()
    }
}
