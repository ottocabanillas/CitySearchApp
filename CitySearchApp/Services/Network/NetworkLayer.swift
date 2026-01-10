//
//  NetworkLayer.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation

protocol NetworkService {
    func fetchData<T: Decodable>(_ requestModel: RequestModel) async throws -> T
}

// MARK: -
final class NetworkLayer: NetworkService {
    func fetchData<T: Decodable>(_ requestModel: RequestModel) async throws -> T {
        var serviceURL = URLComponents(string: requestModel.urlString)
        serviceURL?.queryItems = buildQueryItems(params: requestModel.queryItems ?? [:])
        
        guard let componentURL = serviceURL?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: componentURL)
        request.httpMethod = requestModel.httpMethod.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.httpResponseError
            }
            
            switch httpResponse.statusCode {
            case 200:
                break
            case 400:
                throw NetworkError.badRequest
            case 401:
                throw NetworkError.unauthorized
            case 403:
                throw NetworkError.forbidden
            case 404:
                throw NetworkError.notFound
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.statusCodeError
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw NetworkError.couldNotDecodeData
            }
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.generic
            }
        } catch {
            throw NetworkError.generic
        }
    }
}

//MARK: - Private Methods
extension NetworkLayer {
    private func buildQueryItems(params: [String:String]) -> [URLQueryItem] {
        let items = params.map({URLQueryItem(name: $0, value: $1)})
        return items
    }
}
