//
//  CityListView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

struct CityListView: View {
    @StateObject private var viewModel = CityListViewModel()
    
    var body: some View {
        NavigationStack {
            contentListView
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search for a city"
        )
    }
    
    private var contentListView: some View {
        VStack(spacing: 0){
            VStack {
                Toggle("Show only favorites", isOn: $viewModel.showFavoritesOnly)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 16)
                    .background(Color(.systemGray3))
                    .cornerRadius(16)
            }
            .padding(.vertical, 1)
            listView
        }
        .background(Color(.systemGray5))
    }
    
    private var listView: some View {
        List(viewModel.displayedCities) { city in
            Text(city.name)
        }
        .listStyle(.plain)
    }
}

#Preview {
    CityListView()
}
