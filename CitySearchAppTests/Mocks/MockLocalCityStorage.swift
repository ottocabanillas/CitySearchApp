//
//  MockLocalCityStorage.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 10/01/2026.
//

import Foundation
@testable import CitySearchApp

final class MockLocalCityStorage: CityStorage {
    func load<T: Decodable>(_ type: T.Type) throws -> T {
        <#code#>
    }
    
    func save<T: Encodable>(_ value: T) throws {
        <#code#>
    }
}
