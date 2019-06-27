//
//  Calculator.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/21/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

protocol CalculatorDelegate: class {
    func calculator(_ calculator: Calculator, didUpdateLastOperation operation: String)
    func calculator(_ calculator: Calculator, didUpdateDescription description: String)
    func calculator(_ calculator: Calculator, didUpdateMemory memory: String)
}

class Calculator: NSObject {
    
    weak var delegate: CalculatorDelegate?
    
    private let operationQueue = OperationQueue()
    
    private var isInTheMiddleOfTyping = false
    private var currentNumericOperandValue: String?
    
    private func containsInCurrentValue(_ value: String) -> Bool {
        if let currentNumeric = self.currentNumericOperandValue {
            return currentNumeric.contains(value)
        }
        
        return false
    }
    
    func setOperand(_ operand: KeyType) {
        if KeyType.numbers.contains(operand) {
            self.currentNumericOperandValue = (self.currentNumericOperandValue ?? "") + "\(operand.numericValue)"
            self.delegate?.calculator(self, didUpdateLastOperation: self.currentNumericOperandValue ?? "")
            return
        }
        
        if operand == .comma, let description = Keypad.keyList[operand]?.description, !self.containsInCurrentValue(description) {
            self.currentNumericOperandValue = (self.currentNumericOperandValue ?? "0") + description
            self.delegate?.calculator(self, didUpdateLastOperation: self.currentNumericOperandValue ?? "")
            return
        } else if operand == .comma {
            return
        }
        
        if let stringValue = self.currentNumericOperandValue, let value = Double(stringValue) {
            self.operationQueue.append(numeric: value)
            self.currentNumericOperandValue = nil
        }
        
        
        
        // check if is not repetetive
        // return and ignore
        
        // check if it not constant
        
        // add operand to queue
        self.operationQueue.append(operand)
        self.delegate?.calculator(self, didUpdateDescription: self.operationQueue.description)
    }
}
