//
//  EntityDetailViewController.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

class EntityDetailViewController: UIViewController {
    
    // Type of Entity
    var typeOfEntityToShow: EntityType?
    
    // Networking Properties
    var starWarsAPIClient = StarWarsAPIClient()

    // Properties
    var allEntities: [StarWarsEntity] = []
    var currentEntity: StarWarsEntity? {
        didSet {
            updateDisplay(for: currentEntity!)
        }
    }
    
    // Data Sources
    lazy var attributesTableDataSource: AttributesTableDataSource = {
        return AttributesTableDataSource(attributes: [], cellConversionDelegate: self)
    }()
    
    lazy var entityPickerDataSource: EntityPickerDataSource = {
        return EntityPickerDataSource(entityNames: [])
    }()
    
    // Storyboard Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attributesTableView: UITableView!
    @IBOutlet weak var entityPickerView: UIPickerView!
    @IBOutlet weak var smallestEntityLabel: UILabel!
    @IBOutlet weak var largestEntityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = typeOfEntityToShow?.rawValue
        
        attributesTableView.dataSource = attributesTableDataSource
        entityPickerView.dataSource = entityPickerDataSource // FIXME: Rename to datasource
        entityPickerView.delegate = self

        fetchData(for: typeOfEntityToShow!)

    }
    
    // MARK: - Data Fetch and Subsequent setup
    func fetchData(for entityType: EntityType) {
        switch entityType {
        case .people:
            starWarsAPIClient.getPeople(completionHandler: setup)
        case .vehicles:
            starWarsAPIClient.getVehicles(completionHandler: setup)
        case .starships:
            starWarsAPIClient.getStarships(completionHandler: setup)
        }
    }
    
    func setup<T: StarWarsEntity>(with entities:[T]?, error: StarWarsAPIError?) {
    
        guard let entities = entities else {
            print(error)
            fatalError("oops") // FIXME: Add real error code
        }
        
        allEntities = entities
        
        let entityNames = allEntities.map { $0.name }
        entityPickerDataSource.update(with: entityNames)
        entityPickerView.reloadAllComponents()
        
        currentEntity = entities.first
        updateSmallestAndLargestBar(using: entities)

        
    }
    
    // MARK: - Update Display
    func updateDisplay(for entity: StarWarsEntity) {
        
        nameLabel.text = entity.name
        
        if let entityWithAttributes = entity as? AttributeRepresentable {
            attributesTableDataSource.update(with: entityWithAttributes.attributes)
            attributesTableView.reloadData()
        }
    }
    
    func updateSmallestAndLargestBar(using entities: [StarWarsEntity]) {
        // Not a huge fan but it works...
        var sortedEntities: [StarWarsEntity] = []
        
        if let peopleEntities = entities as? [Person] {
            sortedEntities = peopleEntities.sorted { $0 < $1 }
            
        } else if let vehicleEntities = entities as? [Vehicle] {
            sortedEntities = vehicleEntities.sorted { $0 < $1 }
            
        } else if let starshipEntities = entities as? [Starship] {
            sortedEntities = starshipEntities.sorted { $0 < $1 }
        }
        
        smallestEntityLabel.text = sortedEntities.first?.name
        largestEntityLabel.text = sortedEntities.last?.name
    }
}

extension EntityDetailViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allEntities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentEntity = allEntities[row]
    }
}

// FIXME: Extract
extension EntityDetailViewController: AttributeCellCurrencyRateDelegate {
    func getConversionRate(completion: @escaping (Double) -> Void) {
        
        let alert = UIAlertController(title: "Conversion Rate", message: "Please specify what 1 Galactic Credit is equivalent to in USD. ", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        
        let finishAction = UIAlertAction(title: "Convert", style: .default) { (alertAction) in
            
            completion(Double(alert.textFields!.first!.text!)!) // FIXME: This needs validation. used observers on the text field.

            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(finishAction)

        present(alert, animated: true, completion: nil)

    }
}

