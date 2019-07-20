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
        let operationType: CalculatorBrain.OperationType?
        let relatedKeyTypes: [KeyType]?
        let alternativeKeyType: KeyType?
        let description: String
        
        init(_ keyType: KeyType, operationType: CalculatorBrain.OperationType? = nil, relatedKeyTypes: [KeyType]? = nil, alternativeKeyType: KeyType? = nil, description: String? = nil) {
            self.keyType = keyType
            self.operationType = operationType
            self.relatedKeyTypes = relatedKeyTypes
            self.alternativeKeyType = alternativeKeyType
            self.description = description ?? "\(keyType.rawValue)"
        }
    }
}
