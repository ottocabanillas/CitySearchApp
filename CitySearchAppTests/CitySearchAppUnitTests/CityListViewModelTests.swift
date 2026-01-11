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
    var mockService: NetworkService!
    var mockStorage: CityStorage!
    
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
