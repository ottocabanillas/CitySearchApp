//
//  CityListViewModelStorageTests.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 12/01/2026.
//

import XCTest
@testable import CitySearchApp

@MainActor
final class CityListViewModelStorageTests: XCTestCase {
    // MARK: - Properties
    var sut: CityListViewModel!
    var mockService: MockNetworkLayer!
    var mockStorage: MockLocalCityStorage!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        mockService = MockNetworkLayer(testData: .cities)
        mockStorage = MockLocalCityStorage()
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        mockStorage = nil
    }
    
    func testLoadFavCitiesWhenStorageReturnsIdsSetsFavIdsCorrectly() {
        // Given
        let expectedFavIds: Set<Int> = [2147714, 4829764]
        
        // When
        sut = CityListViewModel(service: mockService, storage: mockStorage)
        
        // Then
        XCTAssertEqual(sut.favIds, expectedFavIds)
    }
    
    func testLoadFavCitiesWhenStorageThrowsErrorFavIdsRemainsEmpty() {
        // Given
        let expectedFavIds: Set<Int> = []
        
        // When
        mockStorage.shouldThrowErrorOnLoad = true
        sut = CityListViewModel(service: mockService, storage: mockStorage)
        
        // Then
        XCTAssertEqual(sut.favIds, expectedFavIds)
    }
    
    func testSaveFavCitiesWhenStorageSavesSuccessfully() async throws {
        // Given
        let expectedFavIds = [2147714, 4829764, 5551752]
        let city = CityModel(id: 5551752, name: "Arizona", countryCode: "US", coordinates: .init(lat: 34.500301, lon: -111.500977))
        // When
        sut = CityListViewModel(service: mockService, storage: mockStorage)
        await sut.fetchCities()
        sut.toggleFavorite(for: city)
        // Then
        let savedFavIds = sut.favIds.sorted()
        
        XCTAssertEqual(savedFavIds, expectedFavIds)
    }
}
