//
//  BinaryOperation.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/18/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension CalculatorBrain {
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
        var firstOperand: Double
        
        var priority: Priority {
            return self.description == "+" || self.description == "-" ? .low : .high
        }
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
}
