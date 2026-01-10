//
//  MapView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    let viewModel: MapViewModel
    
    var body: some View {
        contentMapView
    }
    
    private var contentMapView: some View {
        Map(position: $cameraPosition) {
            Marker(viewModel.markLabel, coordinate: viewModel.coordinates)
        }
        .onAppear {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: viewModel.coordinates,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }
}

#Preview {
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)
    MapView(viewModel: MapViewModel(city: city))
}
