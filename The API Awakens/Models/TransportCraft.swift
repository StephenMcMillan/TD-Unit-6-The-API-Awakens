//
//  Transport Craft.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A Vehicle in the Star Wars Universe
protocol SingleTransportCraft: StarWarsEntity {
    var name: String { get }
    var manufacturer: String { get }
    var costInCredits: String { get }
    var length: String { get }
    var vehicleClass: String { get }
    var crew: String { get }
}
