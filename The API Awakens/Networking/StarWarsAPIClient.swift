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
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let personResult = try decoder.decode(PersonResult.self, from: data)
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
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let vehicleResult = try decoder.decode(VehicleResult.self, from: data)
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
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let startshipResult = try decoder.decode(StarshipResult.self, from: data)
                    completion(startshipResult.results, nil)
                    
                } catch {
                    completion(nil, .decodingFailure)
                }
                
            } else {
                completion(nil, error)
            }
            
        }
    }
    

    
    
    
    
}
