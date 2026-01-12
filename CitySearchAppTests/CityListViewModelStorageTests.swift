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

}
