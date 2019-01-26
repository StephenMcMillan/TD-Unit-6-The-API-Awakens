//
//  AttributesTableDataSource.swift
//  The API Awakens
//
//  Created by Stephen McMillan on 26/01/2019.
//  Copyright © 2019 Stephen McMillan. All rights reserved.
//

import Foundation
import UIKit

class AttributesTableDataSource: NSObject, UITableViewDataSource {
    
    private var attributes:  [Attribute]
    
    init(attributes: [Attribute]) {
        self.attributes = attributes
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AttributeCell.ReuseIdentifier, for: indexPath) as! AttributeCell
        
        let attribute = attributes[indexPath.row]
        
        cell.attributeDescription.text = attribute.description
        cell.attributeLabel.text = "\(attribute.value)"
        
        return cell        
    }
    
    func update(with attributes: [Attribute]) {
        self.attributes = attributes
    }
}
