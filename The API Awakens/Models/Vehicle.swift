//
//  Vehicle.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A Vehicle in the Star Wars Universe.
struct Vehicle: StarWarsEntity {
    
    var name: String
    var manufacturer: String
    var costInCredits: String
    var length: String
    var vehicleClass: String
    var crew: String
}

// Vehicles can be compared based on their lengths.
extension Vehicle: Comparable {
    static func < (lhs: Vehicle, rhs: Vehicle) -> Bool {
        if let lhsLength = Double(lhs.length), let rhsLength = Double(rhs.length) {
            return lhsLength < rhsLength
        } else {
            fatalError("Incomporable, unable to convert to double.")
        }
    }
}

// Decoding wrapper
struct VehicleResult: Decodable {
    var results: [Vehicle]
}

extension Vehicle: AttributeRepresentable {
    var attributes: [Attribute] {
        return [(description: "Make", value: .text(self.manufacturer)),
                (description: "Cost", value: .currency(Double(self.costInCredits)!)),
                (description: "Length", value: .length(Measurement(value: Double(self.length)!, unit: UnitLength.meters))),
                (description: "Class", value: .text(self.vehicleClass.capitalized)),
                (description: "Crew", value: .text(self.crew))]
    }
}




