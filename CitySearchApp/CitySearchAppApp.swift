//
//  CitySearchAppApp.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

@main
struct CitySearchAppApp: App {
    @StateObject private var orientationObserver = OrientationObserver()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(orientationObserver)
        }
    }
}
