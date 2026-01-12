//
//  ContentView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

struct ContentView: View {
    //MARK: - Properties
    @StateObject private var orientationObserver: OrientationObserver = OrientationObserver()
    @State private var selectedCity: CityModel? = nil
    
    //MARK: - Body
    var body: some View {
        if orientationObserver.isPortrait {
            portraitView
        } else {
            landscapeView
        }
    }
    
    //MARK: - Private Views
    private var portraitView: some View {
        NavigationStack {
            CityListView(onSelectedCity: { city in
                selectedCity = city
            })
            .navigationDestination(item: $selectedCity) { city in
                MapView(viewModel: MapViewModel(city: city))
            }
        }
        .accessibilityIdentifier("PORTRAIT_VIEW")
    }
    
    private var landscapeView: some View {
        HStack {
            NavigationStack {
                CityListView(onSelectedCity: { city in
                    selectedCity = city
                })
            }
            if let city = selectedCity {
                MapView(viewModel: .init(city: city))
                    .id(city.id)
            } else {
                selectMapView
            }
        }
        .accessibilityIdentifier("LANDSCAPE_VIEW")
        .background(Color(.black))
    }
    
    private var selectMapView: some View {
        VStack{
            Text("SELECT_CITY_MESSAGE")
                .font(Font.system(size: 32, weight: .bold))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.white))
    }
}

#Preview {
    ContentView()
        .environmentObject(CityListViewModel(service: NetworkLayer(), storage: LocalCityStorage()))
}
