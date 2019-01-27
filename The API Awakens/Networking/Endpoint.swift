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
}

extension Endpoint {
    var request: URLRequest {
        let url = URL(string: "\(base)\(path)")
        return URLRequest(url: url!)
    }
}

enum StarWars {
    case people
    case vehicles
    case startships
}

extension StarWars: Endpoint {
    
    var base: String {
        return "https://swapi.co/api"
    }
    
    var path: String {
        switch self {
        case .people: return "/people"
        case .vehicles: return "/vehicles"
        case .startships: return "/starships"
        }
    }
}
