//
//  CityDetailViewModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation
import Combine

final class CityDetailViewModel: ObservableObject {
    @Published var description: String = ""
    
    private let city: CityModel
    private let service: NetworkService
    
    var titleLabel: String {
        let cityName = city.name
        let locale = Locale(identifier: "en_US")
        let countryName = locale.localizedString(forRegionCode: city.countryCode) ?? city.countryCode
        return "\(cityName), \(countryName)"
    }
    
    init(city: CityModel, service: NetworkService = NetworkLayer() ) {
        self.city = city
        self.service = service
    }
}

extension CityDetailViewModel {
    func fetchData() async {
        let queryItems = [
            "action": "query",
            "format": "json",
            "generator": "geosearch",
            "ggsradius": "10000",
            "ggslimit": "1",
            "ggscoord": "\(city.coordinates.lat)|\(city.coordinates.lon)",
            "prop": "extracts",
            "exintro": "true",
            "explaintext": "true"
        ]
        let requestModel = RequestModel(httpMethod: .GET, endpoint: .cityInfo, queryItems: queryItems)
        
        do {
            let fetchedCityInfo: CityInfoModel = try await service.fetchData(requestModel)
            await MainActor.run {
                if let extract = fetchedCityInfo.query.pages.values.first?.extract, !extract.isEmpty {
                    self.description = extract
                }
            }
        } catch {
            self.description = "No description available."
            print("Error fetching cities: \(error)")
        }
    }
}
