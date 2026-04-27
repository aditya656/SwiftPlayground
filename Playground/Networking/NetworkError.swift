//
//  NetworkError.swift
//  Playground
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL(String)
    case invalidResponse
    case httpError(statusCode: Int, data: Data)
    case emptyResponseData
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let rawValue):
            return "Invalid URL: \(rawValue)"
        case .invalidResponse:
            return "Invalid response received from the server."
        case .httpError(let statusCode, _):
            return "Request failed with HTTP status code \(statusCode)."
        case .emptyResponseData:
            return "Response did not contain any data."
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
