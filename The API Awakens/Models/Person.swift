//
//  Person.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
// A Person in the Star Wars Universe
struct Person {
    let name: String
    let birthYear: String
    //    let homeworld: Well.. :/
    let height: Double
    let eyeColor: String
    let hairColor: String
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

