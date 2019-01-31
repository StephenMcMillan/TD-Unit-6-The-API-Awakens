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
            
            switch measurement.unit {
            case UnitLength.meters:
                valueStepper.setTitle("Metres", forSegmentAt: 0)
                valueStepper.setTitle("Inches", forSegmentAt: 1)
            case UnitLength.centimeters:
                valueStepper.setTitle("CM", forSegmentAt: 0)
                valueStepper.setTitle("Feet", forSegmentAt: 1)
            default:
                break
            }

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
        
        let roundedValue = (measurement.value * 100).rounded() / 100
        
        if measurement.unit == UnitLength.meters {
            attributeLabel.text = "\(roundedValue)m"
        } else if measurement.unit == UnitLength.inches {
            attributeLabel.text = "\(roundedValue)in"
        } else if measurement.unit == UnitLength.centimeters {
            attributeLabel.text = "\(roundedValue)cm"
        } else if measurement.unit == UnitLength.feet {
            attributeLabel.text = "\(roundedValue)ft"
        }
    }
    
    func update(using currency: Double) {
        attributeLabel.text = "\(currency)"
    }

    @IBAction func stepperChanged(_ sender: UISegmentedControl) {
        
        guard let currentContent = currentContent else { fatalError("rip") }
        
        switch currentContent {
            
        case .length(let measurement):
            
            if measurement.unit == UnitLength.meters || measurement.unit == UnitLength.inches {
                
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
                
            } else if measurement.unit == UnitLength.centimeters || measurement.unit == UnitLength.feet {
                if sender.selectedSegmentIndex == 0 {
                    // Convert to cm
                    let convertedMeasurement = measurement.converted(to: UnitLength.centimeters)
                    self.currentContent = .length(convertedMeasurement)
                    update(using: convertedMeasurement)
                } else if sender.selectedSegmentIndex == 1 {
                    // Convert to feet
                    let convertedMeasurement = measurement.converted(to: UnitLength.feet)
                    self.currentContent = .length(convertedMeasurement)
                    update(using: convertedMeasurement)
                }
            }
            
        case .currency(let currencyValue):            
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
