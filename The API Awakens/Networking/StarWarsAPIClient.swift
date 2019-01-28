//
//  StarWarsAPIClient.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

class StarWarsAPIClient {
    
    let downloader = DataDownloader()
    
    func getPeople(completionHandler completion: @escaping ([Person]?, StarWarsAPIError?) -> Void) {
        
        downloader.get(from: StarWars.people) { data, error in
            
            if let data = data {
                do {
                    
                let personResult = try JSONDecoder.defaultDecoder.decode(PersonResult.self, from: data)
                    completion(personResult.results, nil)
                    
                } catch {
                    completion(nil, .decodingFailure)
                }
     
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    func getVehicles(completionHandler completion: @escaping ([Vehicle]?, StarWarsAPIError?) -> Void) {
        
        downloader.get(from: StarWars.vehicles) { data, error in
            
            if let data = data {
                do {
                    
                    let vehicleResult = try JSONDecoder.defaultDecoder.decode(VehicleResult.self, from: data)
                    
                    completion(vehicleResult.results, nil)
                    
                } catch {
                    completion(nil, .decodingFailure)
                }
                
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    func getStarships(completionHandler completion: @escaping ([Starship]?, StarWarsAPIError?) -> Void) {
        
        downloader.get(from: StarWars.startships) { data, error in
            
            if let data = data {
                do {
                    
                    let starshipResult = try JSONDecoder.defaultDecoder.decode(StarshipResult.self, from: data)
                    
                    completion(starshipResult.results, nil)
                    
                } catch {
                    completion(nil, .decodingFailure)
                }
                
            } else {
                completion(nil, error)
            }
            
        }
    }
    
}

extension JSONDecoder {
    static let defaultDecoder: JSONDecoder = {
       let defaultDecoder = JSONDecoder()
        defaultDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return defaultDecoder
    }()
}
