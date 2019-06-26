//
//  Calculator.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/21/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

struct Calculator {
    
    var currentOperation: String {
        guard let lastOperation = self.operationQueue.last else {
            return ""
        }
        
        return Keypad.masterList[lastOperation]?.description ?? ""
    }
    
    var description: String {
        var text = ""
        self.operationQueue.forEach { operation in
            if let description = Keypad.masterList[operation]?.description {
                text.append(description)
            }
        }
        
        return text
    }
    
    var memory: String {
        return ""
    }
    
    private var operationQueue: [KeyType] = []
    private var isInTheMiddleOfTyping = false
    
    
    mutating func setOperand(_ operand: KeyType) {
        if self.operationQueue.isEmpty {
            self.operationQueue.append(operand)
            return
        }
        
//        guard let lastOperation = self.operationQueue.last else {
//            return
//        }
        
        self.operationQueue.append(operand)
    }
}
