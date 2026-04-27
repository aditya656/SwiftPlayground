//
//  NetworkManager.swift
//  Playground
//

import Foundation

final class NetworkManager: NetworkManaging {
    static let shared = NetworkManager()

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: - Direct GET URL APIs

    func get<T: Decodable>(from urlString: String, as type: T.Type = T.self) async throws -> T {
        let data = try await getData(from: urlString, headers: [:])
        return try decode(type, from: data)
    }

    func getData(from urlString: String, headers: [String: String] = [:]) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL(urlString)
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return try await performDataRequest(request)
    }

    // MARK: - Router APIs

    func request<T: Decodable>(_ router: APIRouter, as type: T.Type = T.self) async throws -> T {
        let data = try await requestData(router)
        return try decode(type, from: data)
    }

    func requestData(_ router: APIRouter) async throws -> Data {
        let request = try router.asURLRequest()
        return try await performDataRequest(request)
    }

    // MARK: - Internal helpers

    private func performDataRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }

        guard !data.isEmpty else {
            throw NetworkError.emptyResponseData
        }

        return data
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
