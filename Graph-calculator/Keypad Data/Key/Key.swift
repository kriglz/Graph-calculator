//
//  Key.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/26/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension Keypad {    
    struct Key {
        
        let keyType: KeyType
        let operationType: OperationType
        let relatedKeyTypes: [KeyType]?
        let description: String
        
        init(number type: KeyType) {
            self.init(keyType: type, operationType: .numeric(Double(type.numericValue)), description: "\(type.rawValue)")
        }
        
        init(keyType: KeyType, operationType: OperationType, relatedKeyTypes: [KeyType]? = nil, description: String) {
            self.keyType = keyType
            self.operationType = operationType
            self.relatedKeyTypes = relatedKeyTypes
            self.description = description
        }
    }
}
