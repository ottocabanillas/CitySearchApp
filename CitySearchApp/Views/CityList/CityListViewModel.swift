//
//  CityListViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Combine
import SwiftUI

final class CityListViewModel: ObservableObject {
    @Published private(set) var displayedCities: [CityModel] = []
    @Published private(set) var allCities: [CityModel] = []
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    
    private var service: NetworkService
    private let storage: Storage
    
    private var favCities: [CityModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(service: NetworkService = NetworkLayer(), storage: Storage = LocalStorage()) {
        self.storage = storage
        self.service = service
        
        loadFavCities()
        bindDisplayedCities()
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
        if let indexInFavs = favCities.firstIndex(where: { $0.id == city.id }) {
            favCities.remove(at: indexInFavs)
            
            if let indexInAll = allCities.firstIndex(where: { $0.id == city.id }) {
                allCities[indexInAll].isFavorite = false
            }
        } else {
            var updatedCity = city
            updatedCity.isFavorite = true
            favCities.append(updatedCity)
            
            if let indexInAll = allCities.firstIndex(where: { $0.id == city.id }) {
                allCities[indexInAll].isFavorite = true
            }
        }
        
        saveFavCities()
    }
}

//MARK: - Search methods
extension CityListViewModel {
    private func resultDisplayed(allCities: [CityModel], searchText: String, favoritesOnly: Bool) -> [CityModel] {
        let prefix = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let source = favoritesOnly ? favCities : allCities
        
        if prefix.isEmpty {
            return source
        }
        
        return source.filter { $0.name.lowercased().hasPrefix(prefix) }
    }
    
    private func bindDisplayedCities() {
        Publishers.CombineLatest3($searchText, $showFavoritesOnly, $allCities)
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.global(qos: .userInitiated))
            .map { [weak self] (text, favOnly, cities) -> [CityModel] in
                guard let self = self else { return [] }
                return self.resultDisplayed(allCities: cities, searchText: text, favoritesOnly: favOnly)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                withTransaction(Transaction(animation: nil)) {
                    self?.displayedCities = result
                }
            }
            .store(in: &cancellables)
    }
    
}

//MARK: - Storage methods
extension CityListViewModel {
    private func loadFavCities() {
        do {
            favCities = try storage.load([CityModel].self)
            print(favCities)
        } catch {
            print("Failed to load favorite cities:", error)
        }
    }
    
    private func saveFavCities() {
        do {
            try storage.save(favCities)
        } catch {
            print("Failed to save favorite cities:", error)
        }
    }
}
