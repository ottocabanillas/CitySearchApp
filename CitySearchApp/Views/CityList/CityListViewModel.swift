//
//  CityListViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Combine
import SwiftUI

final class CityListViewModel: ObservableObject {
    //MARK: - Properties
    @Published private(set) var displayedCities: [CityModel] = []
    @Published private(set) var allCities: [CityModel] = []
    @Published private(set) var responseState: ResponseState = .loading
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    
    private(set) var favIds: Set<Int> = []
    
    private let service: NetworkService
    private let storage: CityStorage
    private let seacher: SearchStrategy = CityBinarySearch()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var favCities: [CityModel] = []
    private var indexById: [Int: Int] = [:]
    
    private var resultCities: [CityModel] = []
    private var pageSize: Int = 50
    private var currentPage: Int = 1
    
    //MARK: - Initialization
    init(service: NetworkService,
         storage: CityStorage
    ) {
        self.storage = storage
        self.service = service
        
        loadFavCities()
        bindDisplayedCities()
    }
}

//MARK: - Network Methods
extension CityListViewModel {
    func fetchCities() async {
        responseState = .loading
        let requestModel = RequestModel(httpMethod: .GET, endpoint: .cities(environment: .prod))
        do {
            let fetchedCities: [CityModel] = try await service.callService(requestModel)
            let sortedCities = fetchedCities.sorted { ($0.name, $0.countryCode) < ($1.name, $1.countryCode) }
            await MainActor.run {
                self.allCities = sortedCities
                self.indexById = Dictionary(
                    uniqueKeysWithValues: allCities.enumerated().map {
                        ($1.id, $0)
                    }
                )
                self.syncFavoriteCities()
                self.responseState = .loaded
            }
        } catch {
            self.responseState = .failed
            print("Error fetching cities: \(error.localizedDescription)")
        }
    }
}

//MARK: - Favorites Methods
extension CityListViewModel {
    func toggleFavorite(for city: CityModel) {
        guard let index = indexById[city.id] else { return }
        allCities[index].isFavorite.toggle()
        updateFavoriteCollections(city: city, index: index)
        saveFavCities()
    }
    
    private func updateFavoriteCollections(city: CityModel, index: Int) {
        if favIds.contains(city.id) {
            favIds.remove(city.id)
            favCities.removeAll { $0.id == city.id }
        } else {
            favIds.insert(city.id)
            favCities.append(allCities[index])
            favCities.sort { ($0.name, $0.countryCode) < ($1.name, $1.countryCode) }
        }
    }
    
    private func syncFavoriteCities() {
        for id in favIds {
            if let index = indexById[id] {
                allCities[index].isFavorite = true
            }
        }
        updateFavoriteCitiesList()
    }
    
    private func updateFavoriteCitiesList() {
        favCities = favIds.compactMap { id in
            guard let index = indexById[id] else { return nil }
            return allCities[index]
        }.sorted { ($0.name, $0.countryCode) < ($1.name, $1.countryCode) }
    }
    
}

//MARK: - Search Methods
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

// MARK: - Pagination Methods
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
            favIds = try storage.load(Set<Int>.self)
        } catch {
            print("Failed to load favorite cities:", error)
        }
    }
    
    private func saveFavCities() {
        do {
            try storage.save(favIds)
        } catch {
            print("Failed to save favorite cities:", error)
        }
    }
}
