////
////  SWAPIClient.swift
////  The API Awakens
////
////  Created by Stephen McMillan on 30/01/2019.
////  Copyright © 2019 Stephen McMillan. All rights reserved.
////
//
//import Foundation
//
//// This class will download all the data and then use the vehicles and starships to help setup instances of person. This is done to limit network requests.
//
//// new approach
//
//// Download all the starships and vehicles. Store them in arrays.
//// Download all the people. Use the url to match starships and vehicles.
//// Make an additional network call for homeworlds.
//
//// Downloading information.
//
//// 1. App launches.
//// 2. Make network call to download people.
//// 1. People downloading using base download method.
//// 2. People download method called recurisvely until no pages left.
//// 3. Call three additional download operations. (Homeworld, Vehicles, Starships) and update the results array.
//// 4. Once all operations have completed we will return the results.
//
//// 3. Repeat for Vehicles and Starships.
//
//// * Downloading all the data at the start will save on API calls? idk
//
//
//class SWAPIClient {
//    var people = [Person]()
//    var vehicles = [Vehicle]()
//    var starships = [Starship]()
//    private var planets = [Planet]()
//
//    func fetchAll(completion: @escaping (Error?) -> Void) {
//        
//        let dispatchGroup = DispatchGroup()
//        
//        // Start with vehicles
//        dispatchGroup.enter()
//        downloadVehicles { (vehicles, error) in
//            
//            if let error = error {
//                completion(error)
//                return
//            }
//            
//            self.vehicles = vehicles!
//            dispatchGroup.leave()
//        }
//        
//        print("a")
//        
//        dispatchGroup.enter()
//        downloadStarships { (starships, error) in
//            
//            if let error = error {
//                completion(error)
//                return
//            }
//            
//            self.starships = starships!
//            dispatchGroup.leave()
//        }
//        
//        print("b")
//        
//        dispatchGroup.enter()
//        downloadPlanets { (planets, error) in
//            
//            if let error = error {
//                completion(error)
//                return
//            }
//            
//            self.planets = planets!
//            dispatchGroup.leave()
//        }
//        
//        print("c")
//        
//        dispatchGroup.wait()
//        
//        downloadPeople { (people, error) in
//            
//            if let error = error {
//                completion(error)
//                return
//            }
//            
//            self.people = people!
//            dump(people)
//        }
//        
//        print("d")
//                
//    }
//    
//    func downloadVehicles(completion: @escaping ([Vehicle]?, Error?) -> Void) {
//        let vehicleDownloader = Downloader<VehicleResult>(endpoint: StarWars.vehicles)
//        
//        vehicleDownloader.getData(completion: completion)
//    }
//    
//    func downloadStarships(completion: @escaping ([Starship]?, Error?) -> Void) {
//        let starshipDownloader = Downloader<StarshipResult>(endpoint: StarWars.startships)
//        
//        starshipDownloader.getData(completion: completion)
//    }
//    
//    func downloadPlanets(completion: @escaping ([Planet]?, Error?) -> Void) {
//        let planetDownloader = Downloader<PlanetResult>(endpoint: StarWars.planets)
//        
//        planetDownloader.getData(completion: completion)
//    }
//    
//    func downloadPeople(completion: @escaping ([Person]?, Error?) -> Void) {
//        let peopleDownloader = Downloader<PersonResult>(endpoint: StarWars.people)
//        
//        peopleDownloader.getData { people, error in
//            
//            if let error = error {
//                completion(nil, error)
//            }
//            
//            guard let people = people else {
//                completion(nil, StarWarsAPIError.unknown)
//                return
//            }
//            
//            // Try and assign appropriate values...
//            
//            // Matching vehicles and starships to characters based on the url property. This is MUCH less demanding on the network.
//            
//            for (index, person) in people.enumerated() {
//                
//                peopleDownloader.results[index].pilotedVehicles = self.vehicles.filter {
//                    return person.vehicles.contains($0.url)
//                }
//                
//                peopleDownloader.results[index].pilotedStarships = self.starships.filter {
//                    return person.starships.contains($0.url)
//                }
//                
//                peopleDownloader.results[index].homeworld = self.planets.first(where: { (planet) -> Bool in
//                    return planet.url == person.homeworldUrl
//                })
//            }
//            
//            completion(peopleDownloader.results, nil)
//        }
//        
//    }
//}
//
