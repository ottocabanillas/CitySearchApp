//
//  CityDetailView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

struct CityDetailView: View {
    let viewModel: CityDetailViewModel
    var body: some View {
        Text(viewModel.titleLabel)
    }
}

#Preview {
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)

    CityDetailView(viewModel: .init(city: city))
}
