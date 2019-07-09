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

    private var brain = CalculatorBrain()
    private var memory = CalculatorMemory()
    
    private var userIsInTheMiddleOfTyping = false
    
    private var displayValue: Double {
        get {
            return Double(self.displayText) ?? 0.0
        } set {
            self.displayText = String(newValue)
        }
    }
    
    private var displayText: String = "" {
        didSet {
            self.delegate?.calculator(self, didUpdateLastOperation: self.displayText)
        }
    }
    
    private var descriptionDisplayText: String = "" {
        didSet {
            self.delegate?.calculator(self, didUpdateDescription: self.descriptionDisplayText)
        }
    }
    
    private var memoryDisplayText: String = "" {
        didSet {
            self.delegate?.calculator(self, didUpdateMemory: self.memoryDisplayText)
        }
    }
    
    func setOperand(_ operand: KeyType) {
        guard let operandDescription = Keypad.keyList[operand]?.description else {
            return
        }
        
        switch operand {
        case .undo:
            self.undoButton()
        case .allClear:
            self.allClearButton()
        case .rand:
            self.randomGenerationButton()
        case .memoryIn:
            self.setMemory()
        case .memoryOut:
            self.getMemory()
            
        default:
            if operand.isNumber || operand == .comma {
                self.addDigit(operandDescription)
            } else {
                self.addMathematicalSymbol(operandDescription)
            }
        }
    }
        
    private func addDigit(_ digit: String) {
        if self.userIsInTheMiddleOfTyping {
            if !self.displayText.contains(".") || digit != "." {
                let textCurrentlyDisplayed = self.displayText
                self.displayText = textCurrentlyDisplayed + digit
            }
        } else {
            self.displayText = digit
            self.userIsInTheMiddleOfTyping = true
        }
    }
    
    private func undoButton() {
        if self.userIsInTheMiddleOfTyping {
            if !self.displayText.isEmpty {
                self.displayText.removeLast()
                if self.displayText.isEmpty {
                    self.displayText = "0.0"
                    self.userIsInTheMiddleOfTyping = false
                }
            }
            if self.descriptionDisplayText.isEmpty {
                self.descriptionDisplayText = " "
            }
        } else {
            brain.undoPreviousOperation()
            displayDescription()
            
            if let result = brain.evaluate(using: memory.storage).result {
                displayValue = result
            }
            displayDescription()
        }
    }
    
    private func allClearButton() {
        self.brain.clearAll()
        self.memory.storage = nil
        self.memoryDisplayText = " "
        self.displayDescription()
        self.userIsInTheMiddleOfTyping = false
    }
    
    private func randomGenerationButton() {
        let maxNumber = Double(UInt32.max)
        let randomNumber = Double(arc4random())
        self.displayValue = randomNumber / maxNumber
        self.userIsInTheMiddleOfTyping = true
    }
    
    private func setMemory() {
        self.memory.storage = ["M": self.displayValue]
        self.memoryDisplayText = "M → " + String(self.displayValue)
        self.userIsInTheMiddleOfTyping = false
        
        if !self.brain.description.isEmpty {
            self.displayText = String(self.brain.evaluate(using: self.memory.storage).result!)
        }
    }
    
    private func getMemory() {
        self.brain.setOperand(variable: "M")
        self.displayValue = memory.storage?["M"] ?? 0
    }
    
    private func addMathematicalSymbol(_ symbol: String) {
        if self.userIsInTheMiddleOfTyping {
            self.brain.setOperand(self.displayValue)
            self.userIsInTheMiddleOfTyping = false
        }
        
        self.brain.setOperand(variable: symbol)
        
        if let result = self.brain.evaluate(using: self.memory.storage).result {
            self.displayValue = result
        }
        
        self.displayDescription()
    }
    
    func displayDescription() {
        if self.brain.evaluate().isPending {
            self.descriptionDisplayText = self.brain.description + "..."
//            self.changeGraphButtonStatusToNotReady()
        } else {
            if !self.brain.description.isEmpty {
                self.descriptionDisplayText = self.brain.description + "="
//                self.changeGraphButtonStatusToReady()
            } else {
                self.displayValue = 0
                self.descriptionDisplayText = "0"
//                self.changeGraphButtonStatusToNotReady()
            }
        }
    }
}
