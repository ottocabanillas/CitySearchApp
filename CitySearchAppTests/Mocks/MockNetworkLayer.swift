//
//  MockNetworkLayer.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 10/01/2026.
//

import Foundation
@testable import CitySearchApp

final class MockNetworkLayer: NetworkService {
    let testData: TestData
    var shouldThrowError: Bool
    var errorToThrow: Error
    
    init(testData: TestData,
         shouldThrowError: Bool = false,
         errorToThrow: Error = NetworkError.couldNotDecodeData
    ) {
        self.testData = testData
        self.shouldThrowError = shouldThrowError
        self.errorToThrow = errorToThrow
    }
    
    func callService<T: Decodable>(_ requestModel: CitySearchApp.RequestModel) async throws -> T {
        if shouldThrowError {
            throw errorToThrow
        }
        guard let result = testData.dataToReturn as? T else {
            throw NSError(domain: "MockNetworkLayer", code: 1)
        }
        return result
    }
}

extension MockNetworkLayer {
    enum TestData {
        case cities
        case infoCity
        
        var dataToReturn: Any {
            switch self {
            case .cities:
                return [
                    CityModel(id: 2147714, name: "Sydney", countryCode: "AU", coordinates: .init(lat: -33.867851, lon: 151.207321)),
                    CityModel(id: 4829764, name: "Alabama", countryCode: "US", coordinates: .init(lat: 32.750408, lon: -86.750259)),
                    CityModel(id: 5323810, name: "Anaheim", countryCode: "US", coordinates: .init(lat: 33.835289, lon: -117.914497)),
                    CityModel(id: 5454711, name: "Albuquerque", countryCode: "US", coordinates: .init(lat: 35.084492, lon: -106.651138)),
                    CityModel(id: 5551752, name: "Arizona", countryCode: "US", coordinates: .init(lat: 34.500301, lon: -111.500977))
                ]
            case .infoCity:
                return CityInfoModel(
                    query: .init(pages: ["63778574": .init(extract: "According to the Köppen climate classification, New York City...")])
                )
            }
        }
    }
}
