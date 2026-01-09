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
            VStack() {
                Text(viewModel.titleLabel)
                    .font(.title2.weight(.bold))
            }
            .padding(.vertical)
            .padding(.horizontal, 16)
            
            ScrollView {
                Text(viewModel.description)
                    .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)

    CityDetailView(viewModel: .init(city: city))
}
