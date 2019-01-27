//
//  Starship.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A Starship in the Star Wars Universe. A vehicle WITH Hyperdrive.
struct Starship: SingleTransportCraft {
    
    var name: String
    var manufacturer: String
    var costInCredits: String
    var length: String
    var vehicleClass: String
    var crew: String
}

struct StarshipResult: Decodable {
    var results: [Starship]
}

extension Starship: AttributeRepresentable {
    var attributes: [Attribute] {
        return [(description: "Make", value: self.manufacturer),
                (description: "Cost", value: self.costInCredits),
                (description: "Length", value: self.length),
                (description: "Class", value: self.vehicleClass),
                (description: "Crew", value: self.crew)]
    }
}

