//
//  ViewController.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 25/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? EntityDetailViewController, let identifier = segue.identifier {
            
            print(identifier)
            
            switch identifier {
            case "ShowPeople":
                detailViewController.typeOfEntityToShow = .people
            case "ShowVehicles":
                detailViewController.typeOfEntityToShow = .vehicles
            case "ShowStarships":
                detailViewController.typeOfEntityToShow = .starships
                
            default:
                fatalError("Somebody messed up badly...")
            }
        }
    }
}

