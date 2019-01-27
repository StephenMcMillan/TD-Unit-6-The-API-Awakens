//
//  RowRepresentable.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

// Allows a type to have its properties represnted in a table view.
typealias Attribute = (description: String, value: AttributeCellContent)

protocol AttributeRepresentable {
    var attributes: [Attribute] { get }
}
