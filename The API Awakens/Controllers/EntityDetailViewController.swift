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
    
    // Properties
    var allEntities: [StarWarsEntity] = []
    var currentEntity: StarWarsEntity? {
        didSet {
            print("Updating...")
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
        
        smallestEntityLabel.isHidden = true
        largestEntityLabel.isHidden = true
        nameLabel.isHidden = true
        
        attributesTableView.dataSource = attributesTableDataSource
        entityPickerView.dataSource = entityPickerDataSource 
        entityPickerView.delegate = self

        fetchData(for: typeOfEntityToShow!)

    }
    
    // MARK: - Data Fetch and Subsequent setup
    func fetchData(for entityType: EntityType) {
        switch entityType {
        case .people:
        
            StarWarsAPIClient.getAllPeople { (people, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                
                if let people = people {
                    self.setup(with: people)
                }
            }
            
        case .vehicles:
        
            StarWarsAPIClient.getAllVehicles { (vehicles, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                
                if let vehicles = vehicles {
                    self.setup(with: vehicles)
                }
            }
            
        case .starships:
            
            StarWarsAPIClient.getAllStarships { (starships, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                
                if let starships = starships {
                    self.setup(with: starships)
                }
            }
            
        }
    }
    
    func setup<Entity: ComparableStarWarsEntity>(with entities: [Entity]) {
        DispatchQueue.main.async {
            self.allEntities = entities
            
            let entityNames = self.allEntities.map { $0.name }
            
            self.entityPickerDataSource.update(with: entityNames)
            self.entityPickerView.reloadAllComponents()
            
            self.updateSmallestAndLargestBar(using: entities)
            
            if entities is [Person] {
                self.showPersonEntity(at: self.allEntities.startIndex) // First item.
            } else {
                self.currentEntity = entities.first
            }
        }
    }
    
    func showPersonEntity(at index: Int) {
        
        if let personEntity = allEntities[index] as? Person {
            
            guard personEntity.homeworld == nil else {
                self.currentEntity = personEntity
                return
            }
            
            StarWarsAPIClient.fetchAssociatedValues(for: personEntity) { (person, error) in
                
                guard let person = person else {
                    fatalError("Oops.") // Fixme: Add alert view to display errors
                }
                
                DispatchQueue.main.async {
                    self.currentEntity = person
                    self.allEntities[index] = person
                }
            }
        }
    }
    
    // MARK: - Update Display
    func updateDisplay(for entity: StarWarsEntity) {
        
        nameLabel.text = entity.name
        nameLabel.isHidden = false
        
        if let entityWithAttributes = entity as? AttributeRepresentable {
            attributesTableDataSource.update(with: entityWithAttributes.attributes)
            attributesTableView.reloadData()
        }
    }
    
    func updateSmallestAndLargestBar<Entity: ComparableStarWarsEntity>(using entities: [Entity]) {
        let sortedEntities = entities.sorted { $0 < $1 }
        
        smallestEntityLabel.text = sortedEntities.first?.name
        largestEntityLabel.text = sortedEntities.last?.name
        
        smallestEntityLabel.isHidden = false
        largestEntityLabel.isHidden = false
    }
}

extension EntityDetailViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allEntities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if allEntities is [Person] {
            showPersonEntity(at: row) // There's additional work to do if the type is Person before updating the UI
        } else {
            self.currentEntity = allEntities[row]
        }
        
    }
}

// FIXME: Extract
extension EntityDetailViewController: AttributeCellCurrencyRateDelegate {
    func getConversionRate(completion: @escaping (Double) -> Void) {
        
       let currnecyAlert = UIAlertController.currencyConversionAlert(completion: completion)

        present(currnecyAlert, animated: true, completion: nil)

    }
}
