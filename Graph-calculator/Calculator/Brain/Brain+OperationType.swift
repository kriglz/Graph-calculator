//
//  Brain+OperationType.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/18/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension CalculatorBrain {
    enum OperationType {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        
        var description: String {
            switch self {
            case .constant:
                return "constant"
            case .unary:
                return "unaryOperation"
            case .binary:
                return "binaryOperation"
            case .equals:
                return "equals"
            }
        }
    }
}
