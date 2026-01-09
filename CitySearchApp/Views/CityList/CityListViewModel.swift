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
    @Published private(set) var responseState: ResponseState = .loading
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
   
    
    private let service: NetworkService
    private let storage: Storage
    private let seacher: SearchStrategy
    
    private var favCities: [CityModel] = []
    private var cancellables = Set<AnyCancellable>()

    private var pageSize: Int = 50
    private var currentPage: Int = 1
    private var resultCities: [CityModel] = []
    
    init(service: NetworkService = NetworkLayer(),
         storage: Storage = LocalStorage(),
         seacher: SearchStrategy = CityBinarySearch()) {

        self.storage = storage
        self.service = service
        self.seacher = seacher
        
        loadFavCities()
        bindDisplayedCities()
    }
}
//MARK: - Network methods
extension CityListViewModel {
    func fetchCities() async {
        responseState = .loading
        let requestModel = RequestModel(httpMethod: .GET, endpoint: .cities(environment: .prod))
        do {
            let fetchedCities: [CityModel] = try await service.fetchData(requestModel)
            let sortedCities = fetchedCities.sorted { ($0.name, $0.countryCode) < ($1.name, $1.countryCode) }
            await MainActor.run {
                self.allCities = sortedCities
                self.syncFavorites()
                responseState = .loaded
            }
        } catch {
            responseState = .failed
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
            .lowercased()
        
        let source = favoritesOnly ? favCities : allCities
        
        if prefix.isEmpty {
            return source
        }
        
        return seacher.search(prefix: prefix, source: source)
    }
    
    private func bindDisplayedCities() {
        Publishers.CombineLatest3($searchText, $showFavoritesOnly, $allCities)
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.global(qos: .userInitiated))
            .map { [weak self] (text, favOnly, cities) -> [CityModel] in
                guard let self = self else { return [] }
                return self.resultDisplayed(allCities: cities, searchText: text, favoritesOnly: favOnly)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                withTransaction(Transaction(animation: nil)) {
                    self.resultCities = result
                    self.currentPage = 1
                    self.applyPagination(on: result)   
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Pagination
extension CityListViewModel {
    private func applyPagination(on list: [CityModel]) {
        let upperBound = min(pageSize * currentPage, list.count)
        self.displayedCities = Array(list.prefix(upperBound))
    }
    
    private func loadNextPage() {
        guard displayedCities.count < resultCities.count else { return }
        currentPage += 1
        applyPagination(on: resultCities)
    }
    
     func loadMoreCities(currentItem: CityModel) {
        guard let index = displayedCities.firstIndex(where: { $0.id == currentItem.id }) else { return }

        let threshold = displayedCities.count - 10

        if index == threshold {
            loadNextPage()
        }
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
