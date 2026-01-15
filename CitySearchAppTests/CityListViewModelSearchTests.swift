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
}
