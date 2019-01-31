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
    static func errorAlert(error: Error?) -> UIAlertController {
        
        let alertError = UIAlertController(title: "Ooops!", message: error?.localizedDescription ?? "An error occured. The source of the error could not be identified.", preferredStyle: .alert)
        return alertError
    }
    
    static func currencyConversionAlert(completion: @escaping (Double) -> Void) -> UIAlertController {
        
        let currencyAlert = UIAlertController(title: "Conversion Rate", message: "Please specify what 1 Galactic Credit is equivalent to in USD. ", preferredStyle: .alert)
        
        currencyAlert.addTextField() { textField in
            textField.placeholder = "1.0"
            textField.addTarget(currencyAlert, action: #selector(currencyAlert.currencyTextFieldValueChanged(_:)), for: .editingChanged)
            
        }
        
        let finishAction = UIAlertAction(title: "Convert", style: .default) { (alertAction) in
            
            completion(Double(currencyAlert.textFields!.first!.text!)!)
            
            currencyAlert.dismiss(animated: true, completion: nil)
        }
        
        finishAction.isEnabled = false
        
        currencyAlert.addAction(finishAction)
        
        return currencyAlert
    }
    
    // Currency Helper
    @objc func currencyTextFieldValueChanged(_ textField: UITextField) {
        // Validation of Currency
        if let text = textField.text, let multiplier = Double(text), multiplier > 0 {
            actions.last?.isEnabled = true
        } else {
            actions.last?.isEnabled = false
        }
    }
}
