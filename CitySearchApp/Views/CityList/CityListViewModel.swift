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
                self.syncFavorites()
            }
        } catch {
            print("Error fetching cities: \(error)")
        }
    }
}

//MARK: - Favorites methods
extension CityListViewModel {
    func toggleFavorite(for city: CityModel) {
        if let indexInFavs = favCities.binarySearchIndex(city) {
            favCities.remove(at: indexInFavs)
            
            if let indexInAll = allCities.binarySearchIndex(city) {
                allCities[indexInAll].isFavorite = false
            }
        } else {
            var updatedCity = city
            updatedCity.isFavorite = true
            favCities.append(updatedCity)
            
            if let indexInAll = allCities.binarySearchIndex(city) {
                allCities[indexInAll].isFavorite = true
            }
        }
        
        saveFavCities()
    }
    
    func syncFavorites() {
        for fav in favCities {
            if let idx = allCities.binarySearchIndex(fav) {
                allCities[idx].isFavorite = true
            }
        }
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


extension Array where Element == CityModel {
    func binarySearchIndex(_ targetCity: CityModel) -> Int? {
        var low = 0
        var high = count - 1

        while low <= high {
            let mid = low + (high - low) / 2
            let midName = self[mid].name
            let midCountry = self[mid].countryCode

            if (midName, midCountry) == (targetCity.name, targetCity.countryCode) {
                return mid
            } else if (midName, midCountry) < (targetCity.name, targetCity.countryCode) {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        return nil
    }
}
