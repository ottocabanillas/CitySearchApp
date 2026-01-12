//
//  CityListViewModelTests.swift
//  CitySearchAppTests
//
//  Created by Oscar Cabanillas on 10/01/2026.
//

import XCTest
@testable import CitySearchApp

@MainActor
final class CityListViewModelTests: XCTestCase {
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
    
    func testFetchCitiesSuccessfulNetworkCallUpdatesCitiesList() async throws {
        //Given
        let responseState: ResponseState = .loaded
        let isEmptyAllCities = false
        
        //When
        await sut.fetchCities()
        
        //Then
        XCTAssertEqual(sut.responseState, responseState)
        XCTAssertEqual(sut.allCities.isEmpty, isEmptyAllCities)
    }
    
    func testFetchCitiesFailedNetworkCall() async throws {
        //Given
        let responseState: ResponseState = .failed
        let isEmptyAllCities = true
        mockService.shouldThrowError = true
        //When
        
        await sut.fetchCities()
        //Then
        XCTAssertEqual(sut.responseState, responseState)
        XCTAssertEqual(sut.allCities.isEmpty, isEmptyAllCities)
    }
}
