//
//  ExampleRouter.swift
//  Playground
//

import Foundation

enum ExampleRouter: APIRouter {
    case users(page: Int)
    case userDetails(id: Int)

    var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }

    var path: String {
        switch self {
        case .users:
            return "users"
        case .userDetails(let id):
            return "users/\(id)"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .users(let page):
            return [URLQueryItem(name: "_page", value: String(page))]
        case .userDetails:
            return []
        }
    }
}
