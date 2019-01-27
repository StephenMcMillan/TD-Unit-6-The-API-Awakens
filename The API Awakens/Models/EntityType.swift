//
//  EntityType.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 27/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// Various Helpers
protocol StarWarsEntity: Decodable {
    var name: String { get set}
}

enum EntityType: String {
    case people = "Characters"
    case vehicles = "Vehicles"
    case starships = "Starships"
}
