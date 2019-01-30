//
//  Endpoint.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
    var request: URLRequest {
        var urlComponents = URLComponents(string: base)!
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return URLRequest(url: urlComponents.url!)
    }
}

enum StarWars {
    case people
    case vehicles
    case startships
}

extension StarWars: Endpoint {
    
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
        switch self {
        case .people: return "/api/people"
        case .vehicles: return "/api/vehicles"
        case .startships: return "/api/starships"
        }
    }
    
    var queryItems: [URLQueryItem] {
        let pageQueryItem = URLQueryItem(name: "page", value: "1")
        return [pageQueryItem]
    }
}
