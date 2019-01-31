//
//  Person.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// A Person in the Star Wars Universe
struct Person: StarWarsEntity {
    var name: String
    var url: String
    
    let birthYear: String
    let homeworldUrl: String
    let height: String
    let eyeColor: String
    let hairColor: String
    let vehicles: [String]
    let starships: [String]
    
    var homeworld: Planet? = nil
    var pilotedVehicles: [Vehicle] = []
    var pilotedStarships: [Starship] = []
    
    private enum CodingKeys: String, CodingKey {
        case name
        case url
        case birthYear
        case homeworldUrl = "homeworld"
        case height
        case eyeColor
        case hairColor
        case vehicles
        case starships
    }
    
}

// People can be compared based on their heights.
extension Person: Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        if let lhsHeight = Double(lhs.height), let rhsHeight = Double(rhs.height) {
            return lhsHeight < rhsHeight
        } else {
            return false // Probably an unknown height...
        }
    }
}

// A wrapper for decoding
struct PersonResult: EntityResult {
    var next: String?
    var results: [Person]
}

extension Person: AttributeRepresentable {
    var attributes: [Attribute] {
        
        var result: [Attribute] = [(description: "Born", value: .text(self.birthYear)),
                 (description: "Homeworld", value: .text(self.homeworld?.name ?? "")),
                 (description: "Height", value: .length(Measurement(value: Double(height) ?? 0, unit: UnitLength.meters))),
                 (description: "Eye Color", value: .text(self.eyeColor.capitalized)),
                 (description: "Hair Color", value: .text(self.hairColor.capitalized))
        ]
        
        for vehicle in pilotedVehicles {
            let attribute = Attribute(description: "Piloted Vehicle", .text(vehicle.name))
            result.append(attribute)
        }
        
        for starship in pilotedStarships {
            let attribute = Attribute(description: "Piloted Starship", .text(starship.name))
            result.append(attribute)
        }
        
        return result
    }
}
