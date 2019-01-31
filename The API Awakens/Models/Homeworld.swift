//
//  Homeworld.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 30/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

struct Planet: StarWarsEntity {
    var name: String
}

extension Planet: Comparable {
    static func < (lhs: Planet, rhs: Planet) -> Bool {
        return lhs.name == rhs.name
    }
}

struct PlanetResult: EntityResult {
    var next: String?
    var results: [Planet]
}
