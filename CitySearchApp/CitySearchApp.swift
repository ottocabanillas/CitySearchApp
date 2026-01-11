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
    @StateObject private var cityLitViewModel: CityListViewModel
    
    init() {
        let useMock = ProcessInfo.processInfo.arguments.contains("--use-mock-network")
        let network: NetworkService = useMock ? MockNetworkLayer(testData: .cities) : NetworkLayer()
        let storage: CityStorage = useMock ? MockLocalCityStorage() : LocalCityStorage()
        _cityLitViewModel = StateObject(wrappedValue: CityListViewModel(service: network, storage: storage))
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cityLitViewModel)
        }
    }
}
