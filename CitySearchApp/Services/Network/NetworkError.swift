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

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .serializationFailed:
            return "Failed while attempting to serialize the request body."
        case .generic:
            return "The app failed due to an unknown error."
        case .couldNotDecodeData:
            return "Failed to decode the response data."
        case .httpResponseError:
            return "Unable to obtain a valid HTTPURLResponse."
        case .statusCodeError:
            return "The status code is different from 200."
        case .noInternetConnection:
            return "No internet connection. Please check your network settings."
        case .timeout:
            return "The request timed out. Please try again."
        case .badRequest:
            return "Bad request. The server could not understand the request."
        case .unauthorized:
            return "Unauthorized. Please check your credentials."
        case .forbidden:
            return "Forbidden. You do not have permission to access this resource."
        case .notFound:
            return "Not found. The requested resource could not be found."
        case .serverError:
            return "Server error. Please try again later."
        case .noData:
            return "No data received from the server."
        }
    }
}
