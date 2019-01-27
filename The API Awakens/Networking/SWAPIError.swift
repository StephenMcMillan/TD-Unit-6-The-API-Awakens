//
//  SWAPIError.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 27/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

enum StarWarsAPIError: Error {
    case badRequest
    case requestUnsuccessful(Int)
    case decodingFailure
    case missingData
}
