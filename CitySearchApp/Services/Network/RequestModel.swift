//
//  RequestModel.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation

struct RequestModel {
    let httpMethod: HTTPMethod
    let endpoint: Endpoint
    var queryItems: [String: String]?
    
    var urlString: String {
        return endpoint.urlString
    }
    
    init(httpMethod: HTTPMethod, endpoint: Endpoint, queryItems: [String : String]? = nil) {
        self.httpMethod = httpMethod
        self.endpoint = endpoint
        self.queryItems = queryItems
    }
}

extension RequestModel {
    enum Endpoint {
        case cities(environment: Environment)
        case cityInfo
        
        var urlString: String {
            return baseURL + path
        }
        
        var baseURL: String {
            switch self {
            case .cities:
                return "https://gist.githubusercontent.com"
            case .cityInfo:
                return "https://en.wikipedia.org/w"
            }
        }
        
        var path: String {
            switch self {
            case let .cities(environment):
                switch environment {
                case .prod:
                    return "/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
                case .dev:
                    return "/ottocabanillas/6f299e1053fd0d0cfd622f2932188c55/raw/4d28af829a1f5f23598f291486353b4c30d4ecf1/cities.json"
                }
            case .cityInfo:
                return "/api.php"
            }
        }
    }
    
    enum HTTPMethod: String {
        case GET, POST, PUT, PATCH, DELETE
    }
    
    enum Environment {
        case prod
        case dev
    }
}
