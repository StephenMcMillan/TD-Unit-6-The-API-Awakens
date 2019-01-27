//
//  StarWarsAPIClient.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

enum StarWarsAPIError: Error {
    case badRequest
    case requestUnsuccessful(Int)
    case decodingFailure
    case missingData
}

class StarWarsAPIClient {
    
    let downloader = DataDownloader()
    
    func getPeople(completionHandler completion: @escaping ([Person]?, StarWarsAPIError?) -> Void) {
        
        downloader.get(from: StarWars.people) { data, error in
            
            if let data = data {
                do {
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let personResult = try decoder.decode(PersonResult.self, from: data)
                    completion(personResult.results, nil)
                    
                } catch {
                    
                    completion(nil, .decodingFailure)
                }
     
            } else {
                // error
            }
            
        }
    }
    
    func getVehicles(completionHandler completion: @escaping ([Vehicle]?, StarWarsAPIError?) -> Void) {
        
        downloader.get(from: StarWars.vehicles) { data, error in
            
            if let data = data {
                do {
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                    let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    dump(json)
                    
                    let vehicleResult = try decoder.decode(VehicleResult.self, from: data)
                    completion(vehicleResult.results, nil)
                    
                } catch {
                    print(error)
//                    completion(nil, .decodingFailure)
                }
                
            } else {
                // error
            }
            
        }
    }

    
    
    
    
}
