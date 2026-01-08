//
//  NetworkError.swift
//  CitySearchApp
//
//  Created by Oscar Cabanillas on 07/01/2026.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL
    case serializationFailed
    case generic
    case couldNotDecodeData
    case httpResponseError
    case statusCodeError
    case noInternetConnection
    case timeout
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case noData
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The URL is invalid.", comment: "")
        case .serializationFailed:
            return NSLocalizedString("Failed while attempting to serialize the request body.", comment: "")
        case .generic:
            return NSLocalizedString("The app failed due to an unknown error.", comment: "")
        case .couldNotDecodeData:
            return NSLocalizedString("Failed to decode the response data.", comment: "")
        case .httpResponseError:
            return NSLocalizedString("Unable to obtain a valid HTTPURLResponse.", comment: "")
        case .statusCodeError:
            return NSLocalizedString("The status code is different from 200.", comment: "")
        case .noInternetConnection:
            return NSLocalizedString("No internet connection. Please check your network settings.", comment: "")
        case .timeout:
            return NSLocalizedString("The request timed out. Please try again.", comment: "")
        case .badRequest:
            return NSLocalizedString("Bad request. The server could not understand the request.", comment: "")
        case .unauthorized:
            return NSLocalizedString("Unauthorized. Please check your credentials.", comment: "")
        case .forbidden:
            return NSLocalizedString("Forbidden. You do not have permission to access this resource.", comment: "")
        case .notFound:
            return NSLocalizedString("Not found. The requested resource could not be found.", comment: "")
        case .serverError:
            return NSLocalizedString("Server error. Please try again later.", comment: "")
        case .noData:
            return NSLocalizedString("No data received from the server.", comment: "")
        }
    }
}
