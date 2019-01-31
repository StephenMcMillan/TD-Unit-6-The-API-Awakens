//
//  EntityDetailViewController+Delegates.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 31/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit

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

extension EntityDetailViewController: AttributeCellCurrencyRateDelegate {
    func getConversionRate(completion: @escaping (Double) -> Void) {
        
        let currnecyAlert = UIAlertController.currencyConversionAlert(completion: completion)
        
        present(currnecyAlert, animated: true, completion: nil)
        
    }
}
