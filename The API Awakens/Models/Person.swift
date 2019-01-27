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
    
    let birthYear: String
    //    let homeworld: Well.. :/
    let height: String
    let eyeColor: String
    let hairColor: String
}

// A wrapper for decoding
struct PersonResult: Decodable {
    var results: [Person]
}

extension Person: AttributeRepresentable {
    var attributes: [Attribute] {
        return [(description: "Born", value: self.birthYear),
                 (description: "Homeworld", value: "Fix me"),
                 (description: "Height", value: self.height),
                 (description: "Eye Color", value: self.eyeColor),
                 (description: "Hair Color", value: self.hairColor)]
    }
}

