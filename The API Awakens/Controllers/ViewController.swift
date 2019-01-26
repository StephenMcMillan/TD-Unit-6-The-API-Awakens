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
        
        if let navigationController = segue.destination as? UINavigationController, let detailViewController = navigationController.topViewController as? EntityDetailViewController {
            print("Callign...")
            
            let vehicle = Vehicle(name: "Sand Crawler", manufactuer: "Corellia Mining Corporation", costInCredits: 150000, length: 36.8, vehicleClass: "wheeled", crew: 46)
            
            let lukeSkywalker = Person(name: "Luke Skywalker", birthYear: "19BBY", height: 172.0, eyeColor: "blue", hairColor: "blond")

            detailViewController.entity = Entity.person(lukeSkywalker)
        }
    }


}

