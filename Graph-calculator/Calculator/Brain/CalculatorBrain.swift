//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Kristina Gelzinyte on 5/23/17.
//
//

import Foundation

struct CalculatorBrain {
    
    private var descriptionArray = [String]()
    private var canAppend = true
    private var currentAngleUnit = AngleUnit.radian

    private var operations: Dictionary<String, OperationType> = [
        "π": OperationType.constant(Double.pi),
        "e": .constant(M_E),
        
        "√": OperationType.unary(sqrt),
        "ⁿ√": OperationType.binary({ pow($0, (1 / $1))}),
        
        "cos": OperationType.unary({ cos($0).rounded(to: 15)}),
        "sin": OperationType.unary({ sin($0).rounded(to: 15)}),
        "tan": OperationType.unary({ sin($0).rounded(to: 15) / cos($0).rounded(to: 15)}),
        "cos-1": OperationType.unary(acos),
        "sin-1": OperationType.unary(asin),
        "tan-1": OperationType.unary(atan),
        
        "cosh": OperationType.unary(cosh),
        "sinh": OperationType.unary(sinh),
        "tanh": OperationType.unary(tanh),
        "cosh-1": OperationType.unary(acosh),
        "sinh-1": OperationType.unary(asinh),
        "tanh-1": OperationType.unary(atanh),
        
        "x²": OperationType.unary({ pow($0, 2)}),
        "xⁿ": OperationType.binary({ pow($0, $1)}),
        "eˣ": OperationType.unary(exp),

        "log10": OperationType.unary(log10),
        "ln": OperationType.unary({ log($0) / log(M_E)}),
        "logY": OperationType.binary({ log($0) / log($1)}),

        "±": OperationType.unary({ -$0}),
        "％": OperationType.unary({ $0 / 100}),
        "x!": OperationType.unary({ $0.factorial}),

        "×": OperationType.binary({ $0 * $1}),
        "÷": OperationType.binary({ $0 / $1}),
        "+": OperationType.binary({ $0 + $1}),
        "-": OperationType.binary({ $0 - $1}),
        
        "=": OperationType.equals
    ]
    
    mutating func setOperand (_ operand: Double){
        let valueToCheck = OperandValue.numeric(operand)
        updateCurrentOperations(for: valueToCheck)
        descriptionArray.append(String(operand))
    }
    
    mutating func setOperand (variable named: String){
        let valueToCheck = OperandValue.nonNumeric(named)
        updateCurrentOperations(for: valueToCheck)
        if canAppend {
            descriptionArray.append(named)
        } else {
            canAppend = true
        }
    }
    
    mutating func switchAngleUnit(to unit: AngleUnit) {
        self.currentAngleUnit = unit
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool) {
        let operationResult = performOperations(descriptionArray, memoryValue: variables?["M"], variableXValue: variables?["x"])
        return (result: operationResult.result, isPending: operationResult.isPending)
    }
    
    private func performOperations(_ operationArray: [String], memoryValue: Double? = nil, variableXValue: Double? = nil) -> (result: Double?, isPending: Bool) {
        var accumulation: Double = 0
        var resultIsPending = false
        
        let binaryOperationQueue = BinaryOperatioQueue()
        
        for element in operationArray {
            if Double(element) != nil {
                accumulation = Double(element)!
                resultIsPending = binaryOperationQueue.hasPendingOperations
                
            } else if element == "M" {
                accumulation = memoryValue == nil ? 0 : memoryValue!
                resultIsPending = false
                
            } else if element == "x" {
                accumulation = variableXValue == nil ? 0 : variableXValue!
                resultIsPending = false
                
            } else if let operation = operations[element] {
                switch operation {
                case .constant(let value):
                    accumulation = value
                    if !binaryOperationQueue.hasPendingOperations {
                        resultIsPending = false
                    }
                    
                case .unary(let function):
                    accumulation = function(accumulation * self.multiplierForOperation(element)) * self.inverseMultiplierForOperation(element)
                    resultIsPending = binaryOperationQueue.hasPendingOperations
                  
                case .binary(let function):
                    let operation = BinaryOperation(function: function, description: element, firstOperand: accumulation)
                    binaryOperationQueue.append(operation)
                    resultIsPending = true
                    
                case .equals:
                    if binaryOperationQueue.hasPendingOperations {
                        accumulation = binaryOperationQueue.perform(with: accumulation) ?? 0
                    }
                    resultIsPending = false
                }
            }
        }
        
        return (accumulation, resultIsPending)
    }
    
    private func multiplierForOperation(_ operation: String) -> Double {
        return operation == "sin" || operation == "cos" || operation == "tan" ? self.currentAngleUnit.multiplier : 1
    }
    
    private func inverseMultiplierForOperation(_ operation: String) -> Double {
        return operation == "sin-1" || operation == "cos-1" || operation == "tan-1" ? 1 / self.currentAngleUnit.multiplier : 1
    }
    
    private mutating func updateCurrentOperations(for operandValue: OperandValue) {
        switch operandValue {
        case .numeric:
            /*
             TYPE NUMBER:
             1. if the last element in the array is a number -> delete array, start new one.
             2. if the last element is .constant -> delete array, start new one.
             3. if the last element is M -> delete array, start new one.
             */
            if let lastElementIndex = descriptionArray.index(descriptionArray.endIndex, offsetBy: -1, limitedBy: descriptionArray.startIndex)
            {
                let lastElement = descriptionArray[lastElementIndex]
                let oldOperation = operationType(for: lastElement)
                
                if Double(lastElement) != nil ||  oldOperation == "unaryOperation" || oldOperation == "constant" || oldOperation == "equals" || lastElement == "M" || lastElement == "x" {

                    descriptionArray.removeAll()
                }
            }

        case .nonNumeric(let symbol):
            /*
             TYPE M:
             1. if the last element is M -> delete array last member, start new one.
             2. if the last element in the array is a number -> delete array, start new one.
             3. if the last element is .constant -> delete array, start new one.
             
             TYPE .CONSTANT:
             1. if the last element in the array is a number -> delete array, start new one.
             2. if the last element is .constant -> delete array, start new one.
             3. if the last element is M -> delete array, start new one.
             
             TYPE .UNARYOPERATION:
             1. if the last element in the array is a symbol -> do nothing? -> calculate the answer
             
             TYPE .BINARYOPERATION:
             1. if the last element in the array is a binaryOperation -> delete last element in an array and add the new one             */
            if let lastElementIndex = descriptionArray.index(descriptionArray.endIndex, offsetBy: -1, limitedBy: descriptionArray.startIndex) {
                let lastElement = descriptionArray[lastElementIndex]
                
                let newOperation = operationType(for: symbol)
                let oldOperation = operationType(for: lastElement)
                
                
                if newOperation == "constant" && (Double(lastElement) != nil || oldOperation == "constant" || oldOperation == "unaryOperation" || lastElement == "M" || lastElement == "x" || oldOperation == "equals" ) {
                    descriptionArray.removeAll()
                }
                if (newOperation == "unaryOperation" || newOperation == "binaryOperation") && oldOperation == "binaryOperation" {
                    descriptionArray.removeLast()
                }
                if newOperation == "equals" && oldOperation == "binaryOperation" {
                    let element = String(evaluate().result!)
                    let index = descriptionArray.endIndex
                    descriptionArray.insert(element, at: index)
                }
                if (oldOperation == "equals" || oldOperation == "unaryOperation" || oldOperation == "constant") && (symbol == "M" || symbol == "x") {
                    descriptionArray.removeAll()
                }
                
                if newOperation == "equals" && oldOperation == "equals" {
                    descriptionArray.removeLast()
                }
                
                if (symbol == "M" || symbol == "x") && (lastElement == "M" || lastElement == "x") {
                    descriptionArray.removeLast()
                }
                
                if symbol == "x" && oldOperation == nil && !descriptionArray.isEmpty {
                    descriptionArray.removeLast()
                }
                
                if symbol == "±" && lastElement == "±" {
                    descriptionArray.removeLast()
                    canAppend = false
                }
            } else {
                let newOperation = operationType(for: symbol)
                if !(newOperation == "constant" || symbol == "M" || symbol == "x") {
                    descriptionArray.append("0.0")
                }
            }
        }
    }
    
    private func operationType(for element: String) -> String? {
        return operations[element]?.description
    }

    mutating func undoPreviousOperation() {
        if descriptionArray.last == "=" {
            descriptionArray.removeLast()
        }
        if !descriptionArray.isEmpty {
            descriptionArray.removeLast()
        }
    }
    
    mutating func clearAll() {
        descriptionArray.removeAll()
    }
    
    var description: String {
        get {
            var displayArray = [String]()
            var partialArray = [String]()
            var repetetiveNumber = 2
            var lastOperationType = ""
            
            for element in descriptionArray {
                partialArray.append(element)
                
                if let value = Double(element) {
                    displayArray.append(value.roundedToIntIfNeededString)
                 
                } else if element == "M" || element == "x" {
                    displayArray.append(element)
                    
                } else if element == "x²" {
                    if lastOperationType == "equals" {
                        displayArray.insert("(", at: displayArray.startIndex)
                        
                    } else if lastOperationType == "unaryOperation" {
                        displayArray.insert("(", at: displayArray.index(before: displayArray.endIndex - repetetiveNumber))
                        repetetiveNumber += 2
                    
                    } else {
                        displayArray.insert("(", at: displayArray.index(before: displayArray.endIndex))
                    }
                    
                    displayArray.append(")" + "²")
                    
                } else if element == "±" {
                    if performOperations(partialArray).result! < 0 {
                        if lastOperationType == "equals" || lastOperationType == "unaryOperation" {
                            displayArray.insert("-" + "(", at: descriptionArray.startIndex)
                            displayArray.append(")")
                        } else if lastOperationType == "binaryOperation" {
                            displayArray.insert("(" + "-", at: displayArray.index(before: displayArray.endIndex))
                            displayArray.append(")")
                        } else {
                            displayArray.insert("-", at: displayArray.index(before: displayArray.endIndex))
                        }
                        
                    } else if performOperations(partialArray).result! > 0 {
                        if lastOperationType == "equals" || lastOperationType == "unaryOperation" {
                            displayArray.insert("-" + "(", at: descriptionArray.startIndex)
                            displayArray.append(")")
                        }
                        else {
                            displayArray.insert("-,", at: displayArray.index(before: displayArray.endIndex))
                        }
                    }
                
                } else if let newOperationName = operationType(for: element), newOperationName != "equals" {
                    if (newOperationName == "binaryOperation" && lastOperationType != "equals") || newOperationName == "constant" {
                        displayArray.append(element)
                    } else {
                        if (newOperationName == "binaryOperation" && lastOperationType == "equals") {
                            displayArray.insert("(", at: displayArray.startIndex)
                            displayArray.append(")" + element)
                            
                        } else if lastOperationType == "equals" {
                            displayArray.insert(element + "(", at: displayArray.startIndex)
                            displayArray.append(")")
                            
                        } else {
                            if lastOperationType == "unaryOperation" && newOperationName == "unaryOperation" {
                                displayArray.insert(element + "(", at: displayArray.index(before: displayArray.endIndex - repetetiveNumber))
                                repetetiveNumber += 2
                                
                            } else {
                                displayArray.insert(element + "(", at: displayArray.index(before: displayArray.endIndex))
                            }
                            displayArray.append(")")
                        }
                    }
                }
                
                lastOperationType = operationType(for: element) ?? ""
            }
            
            var entireString = ""
            for element in displayArray where element != "=" {
                entireString.append(element)
            }
            return entireString
        }
    }
}
