//
//  CitySearchApp.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

@main
struct CitySearchApp: App {
    //MARK: - Body
    private let cityListViewModel: CityListViewModel
    private let cityDetailService: NetworkService
    
    init() {
        let useMock = ProcessInfo.processInfo.arguments.contains("--use-mock")
        
        let cityListService: NetworkService = true ? MockNetworkLayer(testData: .cities) : NetworkLayer()
        let storage: CityStorage = true ? MockLocalCityStorage() : LocalCityStorage()
        self.cityListViewModel = .init(service: cityListService, storage: storage)
        
        self.cityDetailService = true ? MockNetworkLayer(testData: .infoCity) : NetworkLayer()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                cityListViewModel: cityListViewModel,
                cityDetailService: cityDetailService
            )
        }
    }
}
