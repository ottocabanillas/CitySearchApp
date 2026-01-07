//
//  ContentView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var orientationObserver: OrientationObserver
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)
    
    
    var body: some View {
        if orientationObserver.isPortrait {
            portraitView
        } else {
            landscapeView
        }
    }
    
    private var portraitView: some View {
        CityListView()
    }
    
    private var landscapeView: some View {
        HStack {
            CityListView()
            MapView(viewModel: .init(city: city))
        }
        .background(Color(.black))
    }
}

#Preview {
    ContentView()
        .environmentObject(OrientationObserver())
}
