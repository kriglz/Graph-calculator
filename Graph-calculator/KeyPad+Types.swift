//
//  OperationType.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension KeyPadViewController {
    enum Number: Int, CaseIterable {
        case zero = 0
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
    }
    
    enum Operation: CaseIterable {
        case equal
        case sum
        case difference
        case multiplication
        case division
        
        case comma
        case allClear
        case undo
        case redo
        case signChange
        case percentage
        
        case sin
        case cos
        case tan
        case cot
        
        case pi
        case e
        case random
        
        var stringRepresentation: String {
            switch self {
            case .equal:
                return "="
            case .sum:
                return "+"
            case .difference:
                return "-"
            case .multiplication:
                return "×"
            case .division:
                return "÷"
                
            case .comma:
                return "." // ","
            case .allClear:
                return "AC"
            case .undo:
                return "↩︎"
            case .redo:
                return "↪︎"
            case .signChange:
                return "±"
            case .percentage:
                return "％"
                
            case .sin:
                return "sin"
            case .cos:
                return "cos"
            case .tan:
                return "tan"
            case .cot:
                return "cot"
                
            case .pi:
                return "π"
            case .e:
                return "e"
            case .random:
                return "Rand"

            @unknown default:
                return ""
            }
        }
        
        var alternativeOperations: [Operation] {
            switch self {
            case .sin:
                return [self, .cos, .tan, .cot]
            default:
                return [self]
            }
        }
    }
}
