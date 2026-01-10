//
//  CitySearchAppApp.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

@main
struct CitySearchAppApp: App {
    //MARK: - Properties
    @StateObject private var orientationObserver = OrientationObserver()
    
    //MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(orientationObserver)
        }
    }
}
