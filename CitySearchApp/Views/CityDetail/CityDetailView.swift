//
//  CityDetailView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

struct CityDetailView: View {
    @StateObject var viewModel: CityDetailViewModel
    var body: some View {
        detailView
            .task { await viewModel.fetchData() }
    }
    
    private var detailView: some View {
        VStack{
            Text(viewModel.titleLabel)
                .font(.title2.weight(.bold))
                .padding(.bottom, 10)
            JustifiedScrollText(text: viewModel.description)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
    }
}

#Preview {
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)
    
    CityDetailView(viewModel: .init(city: city))
}
