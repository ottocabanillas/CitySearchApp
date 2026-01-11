//
//  MockNetworkLayer.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 10/01/2026.
//

import Foundation
@testable import CitySearchApp

final class MockNetworkLayer: NetworkService {
    func callService<T: Decodable>(_ requestModel: CitySearchApp.RequestModel) async throws -> T {
        <#code#>
    }
}
