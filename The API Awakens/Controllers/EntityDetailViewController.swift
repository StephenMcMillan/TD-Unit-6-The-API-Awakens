//
//  EntityDetailViewController.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class EntityDetailViewController: UIViewController {

    // Properties
    var entity: Entity? {
        didSet {
            configure(with: entity!)
        }
    }
    
    lazy var dataSource: AttributesTableDataSource = {
        return AttributesTableDataSource(attributes: [])
    }()
    
    // Storyboard Outlets
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var attributesTableView: UITableView!
    
    @IBOutlet weak var entityPickerView: UIPickerView!
    
    @IBOutlet weak var smallestEntityLabel: UILabel!
    @IBOutlet weak var largestEntityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributesTableView.dataSource = dataSource
    }

    func configure(with entity: Entity) {
        switch entity {
        case .person(let person):
            print("This is broken lol.")
            dataSource.update(with: person.attributes)
        case .vehicle(let vehicle):
            
            dataSource.update(with: vehicle.attributes)
            
            
            
        case .starship(let startship):
            print("This is broken lol.")
            
        default: break
        }
        
    }
}

enum Entity {
    case person(Person)
    case vehicle(Vehicle)
    case starship(Starship)
}
