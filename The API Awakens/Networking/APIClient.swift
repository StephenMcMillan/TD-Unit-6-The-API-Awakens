//
//  APIClient.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 28/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

class StarWarsAPIClient {
    
    // MARK: - Whole Object Downloaders
    
    static func getAllPeople(completion: @escaping ([Person]?, Error?) -> Void) {
        let peopleDownloader = EntityCollectionDownloader<PersonResult>(endpoint: StarWars.people)
        peopleDownloader.getData(completion: completion)
    }
    
    static func getAllVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void) {
        let vehicleDownloader = EntityCollectionDownloader<VehicleResult>(endpoint: StarWars.vehicles)
        vehicleDownloader.getData(completion: completion)
    }
    
    static func getAllStarships(completion: @escaping ([Starship]?, Error?) -> Void) {
        let starshipDownloader = EntityCollectionDownloader<StarshipResult>(endpoint: StarWars.starships)
        starshipDownloader.getData(completion: completion)
    }
    
    // MARK: - Single Object Downloaders
    
    /// Takes a person instance and downloads the associated homeworld, vehicles and starships.
    static func fetchAssociatedValues(for person: Person, completion: @escaping (Person?, Error?) -> Void) {
        
        var updatedPerson = person
        
        print("Ok we're fetching. lol")
        let dispatchGroup = DispatchGroup()
        
        // 1. Grab the Homeworld from the URL.
        dispatchGroup.enter()
        guard let homeworldUrl = URL(string: person.homeworldUrl) else {
            completion(nil, StarWarsAPIError.invalidHomeworldUrl)
            return
        }
        
        getPlanet(at: homeworldUrl) { planet, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            updatedPerson.homeworld = planet
            dispatchGroup.leave()
        }
        
        // 2. Grab the Associated Vehicles
        for vehicle in person.vehicles {
            guard let vehicleUrl = URL(string: vehicle) else {
                completion(nil, nil) // FIXME:
                return
            }
            
            dispatchGroup.enter()
            getVehicle(at: vehicleUrl) { vehicle, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                updatedPerson.pilotedVehicles.append(vehicle!)
                dispatchGroup.leave()
            }
        }
        
        // 3. Grab the Associated Starships
        for starship in person.starships {
            guard let starshipUrl = URL(string: starship) else {
                completion(nil, nil)
                return
            }
            
            dispatchGroup.enter()
            getStarship(at: starshipUrl) { starship, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                updatedPerson.pilotedStarships.append(starship!)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.wait()
        dump(updatedPerson)
        completion(updatedPerson, nil)
    }
    
    static func getPlanet(at url: URL, completion: @escaping (Planet?, Error?) -> Void) {
        SingleEntityDownloader<Planet>.getData(at: url, completion: completion)
    }
    
    static func getVehicle(at url: URL, completion: @escaping (Vehicle?, Error?) -> Void) {
        SingleEntityDownloader<Vehicle>.getData(at: url, completion: completion)
    }
    
    static func getStarship(at url: URL, completion: @escaping (Starship?, Error?) -> Void) {
        SingleEntityDownloader<Starship>.getData(at: url, completion: completion)
    }

}

/// A class that can download a collection of entities that may be paginated.
class EntityCollectionDownloader<Result: EntityResult> {
    
    var results = [Result.Entity]()
    
    private var nextPage: URLRequest?
    private let urlSession = URLSession(configuration: .default)
    
    init(endpoint: Endpoint) {
        self.nextPage = endpoint.request
    }
        
    func getData(completion: @escaping ([Result.Entity]?, Error?) -> Void) {
        
        guard let nextPageRequest = nextPage else { return }
        
        let dataTask = urlSession.dataTask(with: nextPageRequest) { data, response, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, StarWarsAPIError.requestUnsuccessful(httpResponse.statusCode))
                    return
                }
            }
            
            guard let data = data else {
                completion(nil, StarWarsAPIError.unableToUnpackData)
                return
            }
            
            do {
                
                let decodedResult = try JSONDecoder.defaultDecoder.decode(Result.self, from: data)
                
                self.results.append(contentsOf: decodedResult.results)
                
                if let nextPageUrlString = decodedResult.next, let nextPageUrl = URL(string: nextPageUrlString) {
                    // There is a next page, we need to download it.
                    
                    self.nextPage = URLRequest(url: nextPageUrl)
                    self.getData(completion: completion)

                } else {
                    // There are no further pages, we can exit the downloader and inform the delegate.
                    print(self.results.count)
                    completion(self.results, nil)
                    return
                }
                
            } catch {
                // Likely a decoding error.
                completion(nil, StarWarsAPIError.decodingFailure)
                return
            }
        }
        
        dataTask.resume()
    }
}

/// A simple class for downloading a single entity at a URL.
class SingleEntityDownloader<Entity: StarWarsEntity> {
    static func getData(at url: URL, completion: @escaping (Entity?, Error?) -> Void) {
        
        let urlSession = URLSession(configuration: .default)
        
        let dataTask = urlSession.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(nil, StarWarsAPIError.requestUnsuccessful(httpResponse.statusCode))
                    return
                }
            }
            
            guard let data = data else {
                completion(nil, StarWarsAPIError.unableToUnpackData)
                return
            }
            
            do {
                let decodedResult = try JSONDecoder.defaultDecoder.decode(Entity.self, from: data)
                completion(decodedResult, nil)
            } catch {
                // Likely a decoding error.
                completion(nil, StarWarsAPIError.decodingFailure )
            }
        }
        
        dataTask.resume()
    }
}

extension JSONDecoder {
    static let defaultDecoder: JSONDecoder = {
        let defaultDecoder = JSONDecoder()
        defaultDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return defaultDecoder
    }()
}
