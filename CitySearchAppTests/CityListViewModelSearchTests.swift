//
//  CityListViewModelSearchTests.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 15/01/2026.
//

import XCTest
import Combine
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
        var resultNames: Set<String> = []
        let expectation = XCTestExpectation(description: "displayedCities updated")
        let cancellable = sut.$displayedCities
                .receive(on: DispatchQueue.main)
                .sink { cities in
                    resultNames = Set(cities.map { $0.name })
                    if resultNames == expectedNames {
                        expectation.fulfill()
                    }
                }
        // When
        await sut.fetchCities()
        sut.searchText = "A"
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertEqual(resultNames, expectedNames)
        XCTAssertFalse(resultNames.contains("Sydney"))
        cancellable.cancel()

    }
    
    func testSearchResultsReturnsCitiesStartingWithAl() async throws {
        // Given
        let expectedNames: Set<String> = ["Alabama", "Albuquerque"]
        var resultNames: Set<String> = []
        let expectation = XCTestExpectation(description: "displayedCities updated")
        let cancellable = sut.$displayedCities
                .receive(on: DispatchQueue.main)
                .sink { cities in
                    resultNames = Set(cities.map { $0.name })
                    if resultNames == expectedNames {
                        expectation.fulfill()
                    }
                }
        
        // When
        await sut.fetchCities()
        sut.searchText = "Al"
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertEqual(resultNames, expectedNames)
        XCTAssertFalse(resultNames.contains("Anaheim"))
        XCTAssertFalse(resultNames.contains("Arizona"))
        XCTAssertFalse(resultNames.contains("Sydney"))
        cancellable.cancel()
    }
    
    func testSearchResultsReturnsCitiesStartingWithAlb() async throws {
        // Given
        let expectedNames: Set<String> = ["Albuquerque"]
        var resultNames: Set<String> = []
        let expectation = XCTestExpectation(description: "displayedCities updated")
        let cancellable = sut.$displayedCities
                .receive(on: DispatchQueue.main)
                .sink { cities in
                    resultNames = Set(cities.map { $0.name })
                    if resultNames == expectedNames {
                        expectation.fulfill()
                    }
                }
        
        // When
        await sut.fetchCities()
        sut.searchText = "Alb"
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertEqual(resultNames, expectedNames)
        XCTAssertFalse(resultNames.contains("Alabama"))
        XCTAssertFalse(resultNames.contains("Anaheim"))
        XCTAssertFalse(resultNames.contains("Arizona"))
        XCTAssertFalse(resultNames.contains("Sydney"))
        cancellable.cancel()
    }
    
    func testSearchResultsReturnsCitiesStartingWithS() async throws {
        // Given
        let expectedNames: Set<String> = ["Sydney"]
        var resultNames: Set<String> = []
        let expectation = XCTestExpectation(description: "displayedCities updated")
        let cancellable = sut.$displayedCities
                .receive(on: DispatchQueue.main)
                .sink { cities in
                    resultNames = Set(cities.map { $0.name })
                    if resultNames == expectedNames {
                        expectation.fulfill()
                    }
                }
        
        // When
        await sut.fetchCities()
        sut.searchText = "S"
        await fulfillment(of: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertEqual(resultNames, expectedNames)
        XCTAssertFalse(resultNames.contains("Alabama"))
        XCTAssertFalse(resultNames.contains("Anaheim"))
        XCTAssertFalse(resultNames.contains("Albuquerque"))
        XCTAssertFalse(resultNames.contains("Arizona"))
        cancellable.cancel()
    }
}
