//
//  EntityPickerDataSource.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 27/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit

class EntityPickerDataSource: NSObject, UIPickerViewDataSource {
    
    private var entityNames: [String]
    
    init(entityNames: [String]) {
        self.entityNames = entityNames
    }
    
    func update(with entityNames: [String]) {
        self.entityNames = entityNames
    }
    
    // MARK: - Picker Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return entityNames.count
    }
}
