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
    let onInfoTapped: () -> Void
    let onFavoriteTapped: () -> Void
    
    var body: some View {
        HStack {
            descriptionView
            Spacer()
            buttonsView
        }
        .contentShape(Rectangle())
        .onTapGesture { onCellTapped() }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text(viewModel.titleLabel)
                .font(.headline)
            Text(viewModel.subtitleLabel)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var buttonsView: some View {
        HStack(spacing: 12) {
            Button(action: onInfoTapped) {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            Button(action: onFavoriteTapped) {
                Image(systemName: "heart")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)
    CityCellView(
        viewModel: .init(city: city),
        onCellTapped: { print("Cell tapped") },
        onInfoTapped: { print("Info tapped") },
        onFavoriteTapped: { print("Fav tapped") }
    )
}
