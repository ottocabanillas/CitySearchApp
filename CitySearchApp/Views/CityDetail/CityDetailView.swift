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
        VStack {
            switch viewModel.responseState {
            case .loading:
                ProgressView()
                    .scaleEffect(2.5)
            case .loaded:
                detailView
            case .failed:
                failedView
            }
        }
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
    
    private var failedView: some View {
        VStack(spacing: 16) {
            Text("Failed to load cities. Please try again later.")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Text("😞")
                .font(.system(size: 64))
                .padding(.vertical, 5)
            Button {
                Task { await viewModel.fetchData() }
            } label: {
                Text("Try again")
                    .font(Font.title.bold())
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    let city = CityModel(id: 1, name: "New York", countryCode: "US", coordinates: Coordinates(lat: 40.7128, lon: -74.0060), isFavorite: false)
    
    CityDetailView(viewModel: .init(city: city))
}
