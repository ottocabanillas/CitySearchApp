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
        _cityLitViewModel = StateObject(wrappedValue: CityListViewModel.buildViewModel())
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(cityLitViewModel)
        }
    }
}
