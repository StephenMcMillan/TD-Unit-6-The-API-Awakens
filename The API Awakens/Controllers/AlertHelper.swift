//
//  AlertHelper.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 28/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit


extension UIAlertController {
    
    // Default Alert Config
    static func networkErrorAlert(error: Error?) -> UIAlertController {
        let alertError = UIAlertController(title: "Network Error", message: "Error retrieving information from the network. Error message: \(error?.localizedDescription ?? "Unavailable").", preferredStyle: .alert)
        return alertError
    }
    
    // Currency Helper
    @objc func currencyTextFieldValueChanged(_ textField: UITextField) {
        // Validation of Currency
        
        guard let text = textField.text, text.count > 0 else {
            return
        }
        
        guard let multiplier = Double(text), multiplier > 0 else {
            return
        }
        
        actions.last?.isEnabled = true
    }
}
