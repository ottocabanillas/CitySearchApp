//
//  CityListViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation
import Combine


final class CityListViewModel: ObservableObject {
    @Published private(set) var allCities: [CityModel] = []
    
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    
    private var service: NetworkService
    
    var displayedCities: [CityModel] {
        let prefix = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !prefix.isEmpty else {
            if showFavoritesOnly {
                return allCities.filter { $0.isFavorite }
            }
            return allCities
        }
        if showFavoritesOnly {
            return allCities.filter { $0.isFavorite && $0.name.lowercased().hasPrefix(prefix.lowercased()) }
        }
        return allCities.filter { $0.name.lowercased().hasPrefix(prefix.lowercased()) }
    }
    
    init(service: NetworkService = NetworkLayer()) {
        self.service = service
    }
}
//MARK: - Network methods
extension CityListViewModel {
    func fetchCities() async {
        let requestModel = RequestModel(httpMethod: .GET, endpoint: .cities)
        do {
            let fetchedCities: [CityModel] = try await service.fetchData(requestModel)
            let sortedCities = fetchedCities.sorted { ($0.name, $0.countryCode) < ($1.name, $1.countryCode) }
            await MainActor.run {
                self.allCities = sortedCities
            }
        } catch {
            print("Error fetching cities: \(error)")
        }
    }
}

//MARK: - Favorites methods
extension CityListViewModel {
    func toggleFavorite(for city: CityModel) {
        if let indexInAllCities = allCities.firstIndex(where: { $0.id == city.id }) {
            allCities[indexInAllCities].isFavorite.toggle()
        }
    }
}
