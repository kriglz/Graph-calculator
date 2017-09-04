//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Kristina Gelzinyte on 5/23/17.
//
//

import Foundation

struct CalculatorMemory {
    var storage: Dictionary<String, Double>?
}


struct CalculatorBrain {
    
//Description string made out of description array
    private var descriptionArray: [String] = []
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }

    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "√": Operation.unaryOperation(sqrt),
        "cos": Operation.unaryOperation(cos),
        "sin": Operation.unaryOperation(sin),
        "tan": Operation.unaryOperation(tan),
        "exp": Operation.unaryOperation(exp),
        "x⁻¹": Operation.unaryOperation({ 1 / $0 }),
        "ln": Operation.unaryOperation(log),
        "±": Operation.unaryOperation({ -$0}),
        "×": Operation.binaryOperation({ $0 * $1}),
        "÷": Operation.binaryOperation({ $0 / $1}),
        "+": Operation.binaryOperation({ $0 + $1}),
        "-": Operation.binaryOperation({ $0 - $1}),
        "=": Operation.equals
    ]
 
    
    //set operand for ViewController
    mutating func setOperand (_ operand: Double){
        let valueToCheck = Value.numeric(operand)
        compareOldElement(with: valueToCheck)
        descriptionArray.append(String(operand))
    }
    private var canAppend = true
    mutating func setOperand (variable named: String){
        let valueToCheck = Value.nonNumeric(named)
        compareOldElement(with: valueToCheck)
        if canAppend {
            descriptionArray.append(named)
        } else {
            canAppend = true
        }
    }
    
    
    //calculating CalculatorBrain result by substituting values for those variables found in a supplied Dictionary
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool)//, description: String)
    {
        var evaluateResult: Double?
        if let dictionaryVariables = variables {
            for k in dictionaryVariables.keys {
                switch k {
                case "M":
                    evaluateResult = variables!["M"]
                default:
                    break
                }
            }
        }

        evaluateResult = performOperation(ifMemorySet: evaluateResult, with: descriptionArray).result

        let resultIsPendingResult = performOperation(ifMemorySet: evaluateResult, with: descriptionArray).isPending
        return (result: evaluateResult, isPending: resultIsPendingResult) //, description: description)
    }
    
    
    //performOperations using array elements
    func performOperation(ifMemorySet withValue: Double? = nil, with array: [String]) -> (result: Double?, isPending: Bool) {
        var accumulation: Double?
        var resultIsPending = false
        
        //data structure for BinaryOperartion calculation
        struct PerformBinaryOperation {
            let function: (Double, Double) -> Double
            let firstOperand: Double
            func perform (with secondOperand: Double) -> Double {
                return function(firstOperand, secondOperand)
            }
        }
        //perform BinaryOperation
        var pendingBindingOperation: PerformBinaryOperation?
        func performPendingBinaryOperation() {
            if pendingBindingOperation != nil {
                accumulation = pendingBindingOperation!.perform(with: accumulation ?? 0)
                pendingBindingOperation = nil
            }
        }
        
        for element in array {
            if Double(element) != nil {
                accumulation = Double(element)!
                
                if pendingBindingOperation != nil {
                    resultIsPending = true
                } else {
                    resultIsPending = false
                }
                
            } else {
                if element == "M" {
                    if let value = withValue {
                        accumulation = value
                    }
                    else {
                        accumulation = 0
                    }
                    if pendingBindingOperation != nil {
                        performPendingBinaryOperation()
                        pendingBindingOperation = nil
                    }
                    resultIsPending = false
                }
                if let operation = operations[element]{
                    switch operation {
                        
                    case .constant(let value):
                        accumulation = value
                        if pendingBindingOperation == nil {
                            resultIsPending = false
                        }
                    
                    case .unaryOperation (let function):
                        accumulation = function(accumulation ?? 0)
                        if pendingBindingOperation != nil {
                            resultIsPending = true
                        } else {
                            resultIsPending = false
                        }
                        
                    case .binaryOperation(let function):
                        if pendingBindingOperation != nil {
                            performPendingBinaryOperation()
                            pendingBindingOperation = nil
                        }
                        pendingBindingOperation = PerformBinaryOperation(function: function, firstOperand: accumulation ?? 0)
                        resultIsPending = true
                        
                    case .equals:
                        if pendingBindingOperation != nil {
                            performPendingBinaryOperation()
                            pendingBindingOperation = nil
                        }
                        resultIsPending = false
                    }
                }
            }
        }
        return (accumulation, resultIsPending)
    }
    
    //check if array of operations need to be modified and modify if needed
    enum Value {
        case numeric(Double)
        case nonNumeric(String)
    }
    private mutating func compareOldElement(with newOne: Value) {
        switch newOne {
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
                let oldOperation = getOperationName(of: lastElement)
                
                if Double(lastElement) != nil ||  oldOperation == "unaryOperation" || oldOperation == "constant" || oldOperation == "equals" || lastElement == "M" {

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
                
                let newOperation = getOperationName(of: symbol)
                let oldOperation = getOperationName(of: lastElement)
                
                
                if newOperation == "constant" && (Double(lastElement) != nil || oldOperation == "constant" || oldOperation == "unaryOperation" || lastElement == "M" || oldOperation == "equals" ) {
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
                if (oldOperation == "equals" || oldOperation == "unaryOperation" || oldOperation == "constant") && symbol == "M" {
                    descriptionArray.removeAll()
                }
                
                
                if (symbol == "M" && lastElement == "M") || (newOperation == "equals" && oldOperation == "equals") {
                    descriptionArray.removeLast()
                }
                if symbol == "±" && lastElement == "±" {
                    descriptionArray.removeLast()
                    canAppend = false
                }
            } else {
                let newOperation = getOperationName(of: symbol)
                if !(newOperation == "constant" || symbol == "M") {
                    descriptionArray.append("0.0")
                }
            }
        }
    }
    
    //get operation name based on button title
    private func getOperationName(of operation: String) -> String {
        if let op = operations[operation]{
            switch op {
            case .constant:
                return "constant"
            case .unaryOperation:
                return "unaryOperation"
            case .binaryOperation:
                return "binaryOperation"
            case .equals:
                return "equals"
            }
        }
        return "Can't found"
    }

    
    //undo previous operation
    mutating func undoPreviousOperation() {
        if descriptionArray.last == "=" {
            descriptionArray.removeLast()
        }
        if !descriptionArray.isEmpty {
            descriptionArray.removeLast()
        }
    }
    
    //clearAll description array and reset all instances
    mutating func clearAll() {
        descriptionArray.removeAll()
    }
    
    //description for description dislay
    var description: String {
        get {
            var displayArray = [String]()
            var partialArray = [String]()
            var repetetiveNumber = 1
            var beforeTheLastWasEqual = false
            var lastOperationName = ""
            var newOperationName = ""
            
            
            for element in descriptionArray {
                partialArray.append(element)
                
                //element is a number
                if Double(element) != nil {
                    displayArray.append(element)
                 
                //element is not a number
                } else {
                    newOperationName = getOperationName(of: element)
                    switch element {
                    
                    case "M":
                        displayArray.append(element)
                        
                    case "=":
                        break
                        
                    case "x⁻¹":
                        if lastOperationName == "equals" || beforeTheLastWasEqual{
                            displayArray.insert("(", at: displayArray.startIndex)
                            displayArray.append(")" + "⁻¹")
                            beforeTheLastWasEqual = true
                        } else {
                            if lastOperationName == "unaryOperation" {
                                displayArray.insert("(", at: displayArray.index(before: displayArray.endIndex - repetetiveNumber))
                                repetetiveNumber += 1
                            } else {
                                displayArray.insert("(", at: displayArray.index(before: displayArray.endIndex))
                            }
                            displayArray.append(")" + "⁻¹")
                        }
                        
                    case "±":
                        if performOperation(with: partialArray).result! < 0 {
                            if lastOperationName == "equals" || lastOperationName == "unaryOperation" {
                                displayArray.insert("-" + "(", at: descriptionArray.startIndex)
                                displayArray.append(")")
                            }
                            else if lastOperationName == "binaryOperation" {
                                displayArray.insert("(" + "-", at: displayArray.index(before: displayArray.endIndex))
                                displayArray.append(")")
                            } else {
                                    displayArray.insert("-", at: displayArray.index(before: displayArray.endIndex))
                            }
                        } else {
                            if performOperation(with: partialArray).result! > 0 {
                                if lastOperationName == "equals" || lastOperationName == "unaryOperation" {
                                    displayArray.insert("-" + "(", at: descriptionArray.startIndex)
                                    displayArray.append(")")
                                }
                                else {
                                    displayArray.insert("-,", at: displayArray.index(before: displayArray.endIndex))
                                }
                            }
                        }
                        
                    default:
                    if newOperationName == "binaryOperation" || newOperationName == "constant" {
                        displayArray.append(element)
                    } else {
                            if lastOperationName == "equals" || lastOperationName == "unaryOperation" || beforeTheLastWasEqual{
                                displayArray.insert(element + "(", at: displayArray.startIndex)
                                displayArray.append(")")
                                beforeTheLastWasEqual = true
                            } else {
                                if lastOperationName == "unaryOperation" {
                                    displayArray.insert(element + "(", at: displayArray.index(before: displayArray.endIndex - repetetiveNumber))
                                    repetetiveNumber += 1
                                } else {
                                    displayArray.insert(element + "(", at: displayArray.index(before: displayArray.endIndex))
                                }
                                displayArray.append(")")
                            }
                        }
                    }
                    lastOperationName = newOperationName
                }
            }
            
            var entireString = ""
            for element in displayArray {
                if element != "=" {
                    entireString.append(element)
                }
            }
            return entireString
        }
    }
}
