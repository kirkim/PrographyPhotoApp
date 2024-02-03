//
//  PhotoAppAPI.swift
//  PhotoAppAPI
//
//  Created by 김기림 on 2/3/24.
//

import Foundation

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
}

enum PhotoAppAPI {
    
    case list(page: Int)
    case random
    case detail(id: String)
    
    var method: String {
        switch self {
        default: HTTPMethod.get.rawValue
        }
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        
        return components
    }
    
    var baseURL: String {
        "https://api.unsplash.com"
    }
    
    var urlRequest: URLRequest? {
        var urlComponents = urlComponents
        switch self {
        case .list(let page):
            urlComponents.path = "/photos"
            urlComponents.queryItems = [
                .init(name: "page", value: String(page))
            ]
        case .random:
            urlComponents.path = "/photos/random"
        case .detail(let id):
            urlComponents.path = "/photos/\(id)"
        }
        guard let url = urlComponents.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = [
            "Authorization": "Client-ID _bnOaDVLl1JPqr9rWKEy4OBm6306fSeobdZBUYhbib0"
        ]
        urlRequest.httpMethod = self.method
        print(urlRequest.url)
        return urlRequest
    }
    
}
