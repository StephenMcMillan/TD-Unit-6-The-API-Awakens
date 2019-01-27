//
//  Starship.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A Starship in the Star Wars Universe. A vehicle WITH Hyperdrive.
struct Starship: StarWarsEntity {
    var name: String
    var manufacturer: String
    var costInCredits: String
    var length: String
    var starshipClass: String
    var crew: String
}

// Starships can be compared based on their lengths.
extension Starship: Comparable {
    static func < (lhs: Starship, rhs: Starship) -> Bool {
        if let lhsLength = Double(lhs.length), let rhsLength = Double(rhs.length) {
            return lhsLength < rhsLength
        } else {
            fatalError("Incomporable, unable to convert to double.")
        }
    }
}

// Decoding wrapper
struct StarshipResult: Decodable {
    var results: [Starship]
}

extension Starship: AttributeRepresentable {
    var attributes: [Attribute] {
        return [(description: "Make", value: .text(self.manufacturer)),
                (description: "Cost", value: .currency(Double(self.costInCredits)!)),
                (description: "Length", value: .length(Measurement(value: Double(self.length)!, unit: UnitLength.meters))),
                (description: "Class", value: .text(self.starshipClass.capitalized)),
                (description: "Crew", value: .text(self.crew))]
    }
}

