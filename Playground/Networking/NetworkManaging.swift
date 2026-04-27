//
//  NetworkManaging.swift
//  Playground
//

import Foundation

protocol NetworkManaging {
    func get<T: Decodable>(from urlString: String, as type: T.Type) async throws -> T
    func getData(from urlString: String, headers: [String: String]) async throws -> Data
    func request<T: Decodable>(_ router: APIRouter, as type: T.Type) async throws -> T
    func requestData(_ router: APIRouter) async throws -> Data
}
