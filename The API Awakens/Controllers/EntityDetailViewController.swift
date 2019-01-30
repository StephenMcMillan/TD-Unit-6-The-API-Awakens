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
        
        attributesTableView.dataSource = attributesTableDataSource
        entityPickerView.dataSource = entityPickerDataSource 
        entityPickerView.delegate = self

        fetchData(for: typeOfEntityToShow!)

    }
    
    // MARK: - Data Fetch and Subsequent setup
    func fetchData(for entityType: EntityType) {
        switch entityType {
        case .people:
            let peopleDownloader = Downloader<PersonResult>(endpoint: StarWars.people)
            peopleDownloader.delegate = self
            peopleDownloader.getData()
        case .vehicles:
            let vehicleDownloader = Downloader<VehicleResult>(endpoint: StarWars.vehicles)
            vehicleDownloader.delegate = self
            vehicleDownloader.getData()
        case .starships:
            let starshipsDownloader = Downloader<StarshipResult>(endpoint: StarWars.startships)
            starshipsDownloader.delegate = self
            starshipsDownloader.getData()
        }
    }
    
    func setup<Entity: ComparableStarWarsEntity>(with entities: [Entity], error: Error?) {
            
            self.allEntities = entities
            
            let entityNames = self.allEntities.map { $0.name }
            
            self.entityPickerDataSource.update(with: entityNames)
            self.entityPickerView.reloadAllComponents()
            self.currentEntity = entities.first
            self.updateSmallestAndLargestBar(using: entities)
        
    }
    
    // MARK: - Update Display
    func updateDisplay(for entity: StarWarsEntity) {
        
        nameLabel.text = entity.name
        
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
        currentEntity = allEntities[row]
    }
}

// FIXME: Extract
extension EntityDetailViewController: AttributeCellCurrencyRateDelegate {
    func getConversionRate(completion: @escaping (Double) -> Void) {
        
       let currnecyAlert = UIAlertController.currencyConversionAlert(completion: completion)

        present(currnecyAlert, animated: true, completion: nil)

    }
}

extension EntityDetailViewController: DownloaderDelegate {
    func errorOccuredDuringDownload(error: StarWarsAPIError) {
        
    }
    
    func downloadFinished<Entity: ComparableStarWarsEntity>(results: [Entity]) {
        self.setup(with: results, error: nil)
    }
}
