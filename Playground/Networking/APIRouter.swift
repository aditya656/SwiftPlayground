//
//  APIRouter.swift
//  Playground
//

import Foundation

protocol APIRouter {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
    var timeout: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension APIRouter {
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    var body: Data? { nil }
    var timeout: TimeInterval { 30 }
    var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
}

extension APIRouter {
    func asURLRequest() throws -> URLRequest {
        let endpointURL = baseURL.appendingPathComponent(path)

        var components = URLComponents(url: endpointURL, resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }

        guard let finalURL = components?.url else {
            throw NetworkError.invalidURL("\(baseURL.absoluteString)/\(path)")
        }

        var request = URLRequest(url: finalURL, cachePolicy: cachePolicy, timeoutInterval: timeout)
        request.httpMethod = method.rawValue
        request.httpBody = body

        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
