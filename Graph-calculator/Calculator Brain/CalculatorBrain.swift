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
    
    enum OperationType {
        case numeric(Double)
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        case other
    }
    
    enum AngleUnit {
        case radian
        case degree
        
        var multiplier: Double {
            return self == .degree ? Double.pi / 180 : 1
        }
    }
    
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
    
    private var currentAngleUnit = AngleUnit.radian
    mutating func switchAngleUnit(to unit: AngleUnit) {
        self.currentAngleUnit = unit
    }
    
    //calculating CalculatorBrain result by substituting values for those variables found in a supplied Dictionary
    func evaluate(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, isPending: Bool) {
        var evaluateResultM: Double?
        var evaluateResultX: Double?

        if let dictionaryVariables = variables {
            for k in dictionaryVariables.keys {
                switch k {
                case "M":
                    evaluateResultM = variables!["M"]
                case "x":
                    evaluateResultX = variables!["x"]
                default:
                    break
                }
            }
        }

        let operationResult = performOperations(descriptionArray, memoryValue: evaluateResultM, variableXValue: evaluateResultX)
        return (result: operationResult.result, isPending: operationResult.isPending)
    }
    
    struct BinaryOperation {
        enum Priority: Int, Comparable {
            case low = 1
            case high = 2
            
            static func < (lhs: CalculatorBrain.BinaryOperation.Priority, rhs: CalculatorBrain.BinaryOperation.Priority) -> Bool {
                return lhs.rawValue < rhs.rawValue
            }
        }
        
        let function: (Double, Double) -> Double
        let description: String
        let firstOperand: Double
        
        var priority: Priority {
            return self.description == "+" || self.description == "-" ? .low : .high
        }
        
        func perform (with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    func performOperations(_ operationArray: [String], memoryValue: Double? = nil, variableXValue: Double? = nil) -> (result: Double?, isPending: Bool) {
        var accumulation: Double?
        var resultIsPending = false
        
        var pendingBinaryOperation: BinaryOperation?
        
        func performPendingBinaryOperationIfNeeded() {
            guard let pendingOperation = pendingBinaryOperation else {
                return
            }
            
            accumulation = pendingOperation.perform(with: accumulation ?? 0)
            pendingBinaryOperation = nil
        }
        
        for element in operationArray {
            if Double(element) != nil {
                accumulation = Double(element)!
                resultIsPending = pendingBinaryOperation != nil
                
            } else if element == "M" {
                accumulation = memoryValue == nil ? 0 : memoryValue!
                resultIsPending = false
                
            } else if element == "x" {
                accumulation = variableXValue == nil ? 0 : variableXValue!
                performPendingBinaryOperationIfNeeded()
                resultIsPending = false
                
            } else if let operation = operations[element] {
                switch operation {
                case .constant(let value):
                    accumulation = value
                    if pendingBinaryOperation == nil {
                        resultIsPending = false
                    }
                    
                case .unary(let function):
                    accumulation = function((accumulation ?? 0) * self.multiplierForOperation(element)) * self.inverseMultiplierForOperation(element)
                    resultIsPending = pendingBinaryOperation != nil
                  
                case .binary(let function):
//                    let newPendingOperation = BinaryOperation(function: function, description: element, firstOperand: accumulation ?? 0)
//
//                    if let pendingOperation = pendingBinaryOperation {
//                        if pendingOperation.priority > newPendingOperation.priority {
//                            accumulation = pendingOperation.perform(with: accumulation ?? 0)
//                        } else {
//                            let newAccumulation = newPendingOperation.perform(with: accumulation ?? 0)
//                            accumulation = pendingOperation.perform(with: newAccumulation)
//                            resultIsPending = true
//                        }
//                    }
//
//                    pendingBinaryOperation = newPendingOperation
//                    resultIsPending = true
                    
                    performPendingBinaryOperationIfNeeded()
                    pendingBinaryOperation = BinaryOperation(function: function, description: element, firstOperand: accumulation ?? 0)
                    resultIsPending = true
                    
                case .equals:
                    performPendingBinaryOperationIfNeeded()
                    resultIsPending = false
                    
                default:
                    break
                }
            }
        }
        
        return (accumulation, resultIsPending)
    }
    
    func multiplierForOperation(_ operation: String) -> Double {
        return operation == "sin" || operation == "cos" || operation == "tan" ? self.currentAngleUnit.multiplier : 1
    }
    
    func inverseMultiplierForOperation(_ operation: String) -> Double {
        return operation == "sin-1" || operation == "cos-1" || operation == "tan-1" ? 1 / self.currentAngleUnit.multiplier : 1
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
                
                let newOperation = getOperationName(of: symbol)
                let oldOperation = getOperationName(of: lastElement)
                
                
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
                
                
                if ((symbol == "M" || symbol == "x")  && (lastElement == "M" || lastElement == "x")) || (newOperation == "equals" && oldOperation == "equals") {
                    descriptionArray.removeLast()
                }
                if symbol == "±" && lastElement == "±" {
                    descriptionArray.removeLast()
                    canAppend = false
                }
            } else {
                let newOperation = getOperationName(of: symbol)
                if !(newOperation == "constant" || symbol == "M" || symbol == "x") {
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
            case .unary:
                return "unaryOperation"
            case .binary:
                return "binaryOperation"
            case .equals:
                return "equals"
            default:
                break
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
            var repetetiveNumber = 2
            var lastOperationName = ""
            var newOperationName = ""

            
            for element in descriptionArray {
                partialArray.append(element)
                
                
                //element is a number
                if let value = Double(element) {
                    displayArray.append(value.roundedToIntIfNeededString)
                 
                //element is not a number
                } else {
                    newOperationName = getOperationName(of: element)
                    switch element {
                    
                    case "M":
                        displayArray.append(element)
                        
                    case "x":
                        displayArray.append(element)
                        
                    case "=":
                        break
                        
                    case "x²":
                        if lastOperationName == "equals" {
                            displayArray.insert("(", at: displayArray.startIndex)
                            displayArray.append(")" + "²")
                            
                        } else if lastOperationName == "unaryOperation" {
                            displayArray.insert("(", at: displayArray.index(before: displayArray.endIndex - repetetiveNumber))
                            repetetiveNumber += 2
                        } else {
                            displayArray.insert("(", at: displayArray.index(before: displayArray.endIndex))
                        }
                        displayArray.append(")" + "²")
   
                    case "±":
                        if performOperations(partialArray).result! < 0 {
                            if lastOperationName == "equals" || lastOperationName == "unaryOperation" {
                                displayArray.insert("-" + "(", at: descriptionArray.startIndex)
                                displayArray.append(")")
                            } else if lastOperationName == "binaryOperation" {
                                displayArray.insert("(" + "-", at: displayArray.index(before: displayArray.endIndex))
                                displayArray.append(")")
                            } else {
                                    displayArray.insert("-", at: displayArray.index(before: displayArray.endIndex))
                            }
                            
                        } else if performOperations(partialArray).result! > 0 {
                            if lastOperationName == "equals" || lastOperationName == "unaryOperation" {
                                displayArray.insert("-" + "(", at: descriptionArray.startIndex)
                                displayArray.append(")")
                            }
                            else {
                                displayArray.insert("-,", at: displayArray.index(before: displayArray.endIndex))
                            }
                        }
                        
                    default:
                        
                        if (newOperationName == "binaryOperation" && lastOperationName != "equals") || newOperationName == "constant" {
                            displayArray.append(element)
                        } else {
                            if (newOperationName == "binaryOperation" && lastOperationName == "equals") {
                                displayArray.insert("(", at: displayArray.startIndex)
                                displayArray.append(")" + element)
                                
                            } else if lastOperationName == "equals" {
                                displayArray.insert(element + "(", at: displayArray.startIndex)
                                displayArray.append(")")
                                
                            } else {
                                if lastOperationName == "unaryOperation" && newOperationName == "unaryOperation" {
                                    displayArray.insert(element + "(", at: displayArray.index(before: displayArray.endIndex - repetetiveNumber))
                                    repetetiveNumber += 2
                                    
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
