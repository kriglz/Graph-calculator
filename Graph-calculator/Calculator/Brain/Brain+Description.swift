//
//  Brain+Description.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/23/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension CalculatorBrain {
    var description: GCStringArray {
        let displayArray = GCStringArray()
        var partialArray = [String]()
        var repetetiveNumber = 2
        
        var lastOperationType = ""
        var lastOperationIndex = 0
        
        for element in descriptionArray {
            partialArray.append(element)
            
            if let value = Double(element) {
                displayArray.append(value.roundedToIntIfNeededString)
                lastOperationIndex = displayArray.index(before: displayArray.endIndex)
                
            } else if element == "M" || element == "𝒙" {
                displayArray.append(element)
                lastOperationIndex = displayArray.index(before: displayArray.endIndex)
                
            } else if element == "x²" || element == "x!" {
                if lastOperationType == "equals" {
                    lastOperationIndex = displayArray.startIndex
                    displayArray.insert("(", at: displayArray.startIndex)
                    
                } else if lastOperationType == "unaryOperation" {
                    displayArray.insert("(", at: lastOperationIndex)
                    repetetiveNumber += 2
                    
                } else {
                    let index = displayArray.index(before: displayArray.endIndex)
                    lastOperationIndex = index
                    displayArray.insert("(", at: index)
                }
                
                displayArray.append(")" + String(element.last!))
                
            } else if element == "eˣ" {
                var startIndex = 0
                
                if lastOperationType == "equals" {
                    lastOperationIndex = displayArray.startIndex
                    displayArray.insert("e", at: displayArray.startIndex)
                    displayArray.insert("(", at: displayArray.startIndex + 1)
                    startIndex = displayArray.startIndex + 1
                    
                } else if lastOperationType == "unaryOperation" {
                    displayArray.insert("e", at: lastOperationIndex)
                    displayArray.insert("(", at: lastOperationIndex + 1)
                    startIndex = lastOperationIndex + 1
                    repetetiveNumber += 2
                    
                } else {
                    let index = displayArray.index(before: displayArray.endIndex)
                    lastOperationIndex = index
                    displayArray.insert("e", at: index)
                    displayArray.insert("(", at: index + 1)
                    startIndex = index + 1
                }
                
                displayArray.append(")")
                
                let endIndex = displayArray.endIndex - 1
                for index in startIndex...endIndex {
                    let string = displayArray[index].string
                    displayArray[index] = GCString(string, attributes: [.superscripted: NSRange(location: 0, length: string.count)])
                }
                
            } else if element == "logY" {
                var startIndex = 0
                let prefix = String(element.prefix(3)).gcString
                
                if lastOperationType == "equals" {
                    lastOperationIndex = displayArray.startIndex
                    displayArray.insert(prefix, at: displayArray.startIndex)
                    startIndex = displayArray.startIndex + 1
                    
                } else if lastOperationType == "unaryOperation" {
                    displayArray.insert(prefix, at: lastOperationIndex)
                    startIndex = lastOperationIndex + 1
                    repetetiveNumber += 2
                    
                } else {
                    let index = displayArray.index(before: displayArray.endIndex)
                    lastOperationIndex = index
                    displayArray.insert(prefix, at: index)
                    startIndex = index + 1
                }
                
                let endIndex = displayArray.endIndex - 1
                for index in startIndex...endIndex {
                    let string = displayArray[index].string
                    displayArray[index] = GCString(string, attributes: [.subscripted: NSRange(location: 0, length: string.count)])
                }
                
            } else if element == "sin-1" || element == "cos-1" || element == "tan-1" {
                let prefix = String(element.prefix(3)) + "⁻¹"
                
                if lastOperationType == "equals" {
                    lastOperationIndex = displayArray.startIndex
                    displayArray.insert(prefix + "(", at: displayArray.startIndex)
                    
                } else if lastOperationType == "unaryOperation" {
                    displayArray.insert(prefix + "(", at: lastOperationIndex)
                    repetetiveNumber += 2
                    
                } else {
                    let index = displayArray.index(before: displayArray.endIndex)
                    lastOperationIndex = index
                    displayArray.insert(prefix + "(", at: index)
                }
                
                displayArray.append(")")
                
            } else if element == "sinh-1" || element == "cosh-1" || element == "tanh-1" {
                let prefix = String(element.prefix(4)) + "⁻¹"
                
                if lastOperationType == "equals" {
                    lastOperationIndex = displayArray.startIndex
                    displayArray.insert(prefix + "(", at: displayArray.startIndex)
                    
                } else if lastOperationType == "unaryOperation" {
                    displayArray.insert(prefix + "(", at: lastOperationIndex)
                    repetetiveNumber += 2
                    
                } else {
                    let index = displayArray.index(before: displayArray.endIndex)
                    lastOperationIndex = index
                    displayArray.insert(prefix + "(", at: index)
                }
                
                displayArray.append(")")
                
            } else if element == "±" {
                if performOperations(partialArray).result! < 0 {
                    if lastOperationType == "equals", displayArray.count > 1 {
                        displayArray.insert("-(", at: 0)
                        displayArray.append(")")
                        lastOperationIndex = 0
                        
                    } else if lastOperationIndex != 0 && lastOperationType == "unaryOperation" {
                        displayArray.insert("(-", at: lastOperationIndex)
                        displayArray.append(")")
                        
                    } else if lastOperationType == "binaryOperation" {
                        let index = displayArray.index(before: displayArray.endIndex)
                        lastOperationIndex = index
                        displayArray.insert("(" + "-", at: index)
                        displayArray.append(")")
                        
                    } else if lastOperationIndex == 0 {
                        displayArray.insert("-", at: lastOperationIndex)
                        
                    } else {
                        displayArray.insert("(-", at: lastOperationIndex)
                        displayArray.append(")")
                    }
                    
                } else if performOperations(partialArray).result! > 0 {
                    if lastOperationType == "equals" || lastOperationType == "unaryOperation" {
                        lastOperationIndex = displayArray.startIndex
                        displayArray.insert("-" + "(", at: displayArray.startIndex)
                        displayArray.append(")")
                        
                    } else {
                        let index = displayArray.index(before: displayArray.endIndex)
                        lastOperationIndex = index
                        displayArray.insert("-,", at: index)
                    }
                }
                
            } else if let newOperationName = operationType(for: element), newOperationName != "equals" {
                if (newOperationName == "binaryOperation" && lastOperationType != "equals") || newOperationName == "constant" {
                    displayArray.append(element)
                    lastOperationIndex = displayArray.index(before: displayArray.endIndex)
                } else {
                    if (newOperationName == "binaryOperation" && lastOperationType == "equals") {
                        lastOperationIndex = displayArray.startIndex
                        displayArray.insert("(", at: displayArray.startIndex)
                        displayArray.append(")" + element)
                        
                    } else if lastOperationType == "equals" {
                        lastOperationIndex = displayArray.startIndex
                        displayArray.insert(element + "(", at: displayArray.startIndex)
                        displayArray.append(")")
                        
                    } else {
                        if lastOperationType == "unaryOperation" && newOperationName == "unaryOperation" {
                            displayArray.insert(element + "(", at: lastOperationIndex)
                            repetetiveNumber += 2
                            
                        } else {
                            let index = displayArray.index(before: displayArray.endIndex)
                            lastOperationIndex = index
                            displayArray.insert(element + "(", at: index)
                        }
                        displayArray.append(")")
                    }
                }
            }
            
            lastOperationType = operationType(for: element) ?? ""
        }

        return displayArray
    }
}
