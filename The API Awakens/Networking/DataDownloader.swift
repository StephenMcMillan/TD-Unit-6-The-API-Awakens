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
    
    func get(from endpoint: Endpoint, completionHandler completion: @escaping (Data?, Error?) -> Void) {
        
        let task = session.dataTask(with: endpoint.request) { data, response, error in
            
            // FIXME: This error code needs to propogate errors correctly and handle missing/weak internet connection. The request timed out.
            
            // If data - success
            // else check response then check error.
            
                //print(error?.localizedDescription)
            
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, StarWarsAPIError.badRequest)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print(httpResponse.statusCode)
                    completion(nil, StarWarsAPIError.requestUnsuccessful(httpResponse.statusCode))
                    return
                }
                
                if let data = data {
                    completion(data, nil)
                    
                } else {
                    // This should never execute
                    completion(nil, StarWarsAPIError.missingData)
                }
        }
        
        task.resume()
        
    }
}
