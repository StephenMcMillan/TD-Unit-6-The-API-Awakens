//
//  SWAPIError.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 27/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

enum StarWarsAPIError: Error, LocalizedError {
    case requestUnsuccessful(Int)
    case unableToUnpackData
    case decodingFailure
    case unknown
    case invalidHomeworldUrl
    
    var errorDescription: String? {
        switch self {
        case .requestUnsuccessful(let statusCode):
            return "There was an error requesting the data. Error Code: \(statusCode)."
        case .unableToUnpackData:
            return "There was an error unpacking the data provided by the server."
        case .decodingFailure:
            return "Unable to decode the JSON returned by the server."
        case .unknown:
            return "Unable to identify error source. See source."
        case .invalidHomeworldUrl:
            return "Homeworld was missing from return data. Contact API admin."
        }
    }
}
