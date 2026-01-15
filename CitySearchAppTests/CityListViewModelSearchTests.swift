//
//  CityListViewModelSearchTests.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 15/01/2026.
//

import XCTest
@testable import CitySearchApp

@MainActor
final class CityListViewModelSearchTests: XCTestCase {
    // MARK: - Properties
    var sut: CityListViewModel!
    var mockService: MockNetworkLayer!
    var mockStorage: MockLocalCityStorage!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        mockService = MockNetworkLayer(testData: .cities)
        mockStorage = MockLocalCityStorage()
        sut = CityListViewModel(service: mockService, storage: mockStorage)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        mockStorage = nil
    }
    
    func testSearchResultsReturnsCitiesStartingWithA() async throws {
        // Given
        let expectedNames: Set<String> = ["Alabama", "Anaheim", "Albuquerque", "Arizona"]
        let timeout: TimeInterval = 2.0
        let start = Date()
        var resultNames: Set<String> = []
        
        // When
        await sut.fetchCities()
        sut.searchText = "A"
        
        while Date().timeIntervalSince(start) < timeout {
            resultNames = Set(sut.displayedCities.map { $0.name })
            if resultNames == expectedNames { break }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        
        // Then
        XCTAssertEqual(resultNames, expectedNames)
        XCTAssertFalse(resultNames.contains("Sydney"))

    }
    
    func testSearchResultsReturnsCitiesStartingWithS() async throws {
        // Given
        let expectedNames: Set<String> = ["Sydney"]
        let timeout: TimeInterval = 2.0
        let start = Date()
        var resultNames: Set<String> = []
        
        // When
        await sut.fetchCities()
        sut.searchText = "S"
        
        while Date().timeIntervalSince(start) < timeout {
            resultNames = Set(sut.displayedCities.map { $0.name })
            if resultNames == expectedNames { break }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        
        // Then
        XCTAssertEqual(resultNames, expectedNames)
        XCTAssertFalse(resultNames.contains("Alabama"))
        XCTAssertFalse(resultNames.contains("Anaheim"))
        XCTAssertFalse(resultNames.contains("Albuquerque"))
        XCTAssertFalse(resultNames.contains("Arizona"))
    }
}
