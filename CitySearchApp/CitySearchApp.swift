//
//  CitySearchApp.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

@main
struct CitySearchApp: App {
    //MARK: - Properties
    private let cityListViewModel: CityListViewModel
    private let cityDetailService: NetworkService
    
    //MARK: - Initialization
    init() {
        let storage = Self.makeCityStorage()
        let networkService = Self.makeCityListService()
        self.cityListViewModel = CityListViewModel(service: networkService, storage: storage)
        self.cityDetailService = Self.makeCityDetailService()
    }
    
    //MARK: - Scene
    var body: some Scene {
        WindowGroup {
            ContentView(
                cityListViewModel: cityListViewModel,
                cityDetailService: cityDetailService
            )
        }
    }
}

//MARK: - Private Methods
private extension CitySearchApp {
    
    static func makeCityStorage() -> CityStorage {
        let useMock = ProcessInfo.processInfo.arguments.contains("--use-mock")
        return useMock ? MockLocalCityStorage() : LocalCityStorage()
    }

    static func makeCityListService() -> NetworkService {
        let useMock = ProcessInfo.processInfo.arguments.contains("--use-mock")
        let serviceFailed = ProcessInfo.processInfo.arguments.contains("--service-failed")
        
        if useMock {
            let mock = MockNetworkLayer(testData: .cities)
            mock.shouldThrowError = serviceFailed
            return mock
        }
        
        return NetworkLayer()
    }

    static func makeCityDetailService() -> NetworkService {
        let useMock = ProcessInfo.processInfo.arguments.contains("--use-mock")
        return useMock ? MockNetworkLayer(testData: .infoCity) : NetworkLayer()
    }
}
