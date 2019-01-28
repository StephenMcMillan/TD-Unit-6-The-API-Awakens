//
//  DataDownloader.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation

class DataDownloader {
    
    private let session = URLSession(configuration: .default)
    
    func get(from endpoint: Endpoint, completionHandler completion: @escaping (Data?, StarWarsAPIError?) -> Void) {
        
        let task = session.dataTask(with: endpoint.request) { data, response, error in
            
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, .badRequest)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    completion(nil, .requestUnsuccessful(httpResponse.statusCode))
                    return
                }
                
                if let data = data {
                    completion(data, nil)
                    
                } else {
                    completion(nil, .missingData)
                }
        }
        
        task.resume()
        
    }
}
