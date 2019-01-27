//
//  Vehicle.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A Vehicle in the Star Wars Universe.
struct Vehicle: SingleTransportCraft {
    
    var name: String
    var manufacturer: String
    var costInCredits: String
    var length: String
    var vehicleClass: String
    var crew: String
}

struct VehicleResult: Decodable {
    var results: [Vehicle]
}

extension Vehicle: AttributeRepresentable {
    var attributes: [Attribute] {
        return [(description: "Make", value: self.manufacturer),
                (description: "Cost", value: self.costInCredits),
                (description: "Length", value: self.length),
                (description: "Class", value: self.vehicleClass),
                (description: "Crew", value: self.crew)]
    }
}




