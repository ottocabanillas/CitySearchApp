//
//  CityCellView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

struct CityCellView: View {
    let viewModel: CityCellViewModel
    let onCellTapped: () -> Void
    
    var body: some View {
        HStack {
            descriptionView
                .onTapGesture { onCellTapped() }
            Spacer()
            buttonsView
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.titleLabel)
                .font(.headline)
            Text(viewModel.subtitleLabel)
                .font(.subheadline)
        }
    }
    
    private var buttonsView: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            Button(action: {}) {
                Image(systemName: "heart")
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)
    CityCellView(
        viewModel: .init(city: city),
        onCellTapped: { }
    )
}
