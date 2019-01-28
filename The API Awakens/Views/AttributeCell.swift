//
//  AttributeCell.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import UIKit

// Essentially provides an endpoint for people to specify a custom conversion rate.
protocol AttributeCellCurrencyRateDelegate: class {
    func getConversionRate(completion: @escaping (Double) -> Void)
}

enum AttributeCellContent {
    case text(String)
    case length(Measurement<UnitLength>)
    case currency(Double)
}

class AttributeCell: UITableViewCell {

    static let ReuseIdentifier = "AttributeCell"
    
    var currentContent: AttributeCellContent?

    @IBOutlet weak var attributeDescription: UILabel!
    @IBOutlet weak var attributeLabel: UILabel!
    
    @IBOutlet weak var valueStepper: UISegmentedControl!
    
    var currencyRateDelegate: AttributeCellCurrencyRateDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with content: AttributeCellContent) {
        
        currentContent = content
        
        valueStepper.selectedSegmentIndex = 0
        
        switch content {
        case .text(let value):
            attributeLabel.text = value
            valueStepper.isHidden = true
            
        case .length(let measurement):
            valueStepper.setTitle("Metric", forSegmentAt: 0)
            valueStepper.setTitle("Inches", forSegmentAt: 1)
            valueStepper.isHidden = false
    
            update(using: measurement)
            
        case .currency(let currency):
            valueStepper.setTitle("Credits", forSegmentAt: 0)
            valueStepper.setTitle("USD", forSegmentAt: 1)
            valueStepper.isHidden = false
            
            update(using: currency)
            
        }
    }
    
    // MARK: - Logic for handling unit conversion
    
    func update(using measurement: Measurement<UnitLength>) {
        if measurement.unit == UnitLength.meters {
            attributeLabel.text = "\(measurement.value)m"
        } else if measurement.unit == UnitLength.inches {
            attributeLabel.text = "\(measurement.value.rounded())in"
        }
    }
    
    func update(using currency: Double) {
        attributeLabel.text = "\(currency)"
    }

    @IBAction func stepperChanged(_ sender: UISegmentedControl) {
        
        guard let currentContent = currentContent else { fatalError("rip") }
        
        switch currentContent {
            
        case .length(let measurement):
    
            if sender.selectedSegmentIndex == 0 {
                // Convert to metric
                let convertedMeasurement = measurement.converted(to: UnitLength.meters)
                self.currentContent = .length(convertedMeasurement)
                update(using: convertedMeasurement)
            } else if sender.selectedSegmentIndex == 1 {
                // Convert to inches
                let convertedMeasurement = measurement.converted(to: UnitLength.inches)
                self.currentContent = .length(convertedMeasurement)
                update(using: convertedMeasurement)
            }
            
            
        case .currency(let currencyValue):
            print("Currency conversion logic.")
            
            if sender.selectedSegmentIndex == 0 {
                update(using: currencyValue)
            } else {
                currencyRateDelegate?.getConversionRate { conversionRate in
                    
                    let convertedValue = currencyValue * conversionRate
                    self.update(using: convertedValue)
                }
            }

        default:
            break
        }
        
        
        
    }
}
