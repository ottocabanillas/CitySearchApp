//
//  CityListView.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import SwiftUI

struct CityListView: View {
    //MARK: - Properties
    @EnvironmentObject private var viewModel: CityListViewModel
    @State private var selectedCityForDetails: CityModel? = nil
    var onSelectedCity: ((CityModel) -> Void)? = nil
    
    //MARK: - Body
    var body: some View {
        VStack() {
            VStack {
                Toggle("FAVORITE_TOGGLE_BUTTON", isOn: $viewModel.showFavoritesOnly)
                    .padding()
            }
            .background(Color(.systemGray3))
            VStack {
                switch viewModel.responseState {
                case .loading:
                    ProgressView()
                        .scaleEffect(2.5)
                case .loaded:
                    contentListView
                case .failed:
                    FetchFailedView(action: viewModel.fetchCities)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            if viewModel.allCities.isEmpty {
                await viewModel.fetchCities()
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "SEARCH_PLACEHOLDER"
        )
        .navigationDestination(item: $selectedCityForDetails) { city in
            CityDetailView(viewModel: .init(city: city))
        }
    }
    
    //MARK: - Private Views
    private var contentListView: some View {
        VStack {
            if viewModel.responseState == .loaded,
               viewModel.displayedCities.isEmpty,
               ( !viewModel.searchText.isEmpty || viewModel.showFavoritesOnly ) {
                emptyListView
            } else {
                listView
            }
        }
    }
    
    private var listView: some View {
        List(viewModel.displayedCities) { city in
            CityCellView(
                viewModel: .init(city: city),
                onCellTapped: { onSelectedCity?(city) },
                onInfoTapped: { selectedCityForDetails = city },
                onFavoriteTapped: { viewModel.toggleFavorite(for: city) }
            )
            .onAppear {
                viewModel.loadMoreCities(currentItem: city)
            }
            .accessibilityIdentifier("cityListView.cell_\(city.id)")
        }
        .listStyle(.plain)
    }
    
    private var emptyListView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("NO_RESULT")
                .font(.title2)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        CityListView()
            .environmentObject(CityListViewModel(service: NetworkLayer(), storage: LocalCityStorage()))
    }
}
