//
//  Transport Craft.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A Vehicle in the Star Wars Universe
protocol SingleTransportCraft {
    var name: String { get }
    var manufactuer: String { get }
    var costInCredits: Int { get }
    var length: Double { get }
    var vehicleClass: String { get }
    var crew: Int { get }
}
