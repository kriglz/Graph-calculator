//
//  KeyType.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

enum KeyType: Int, CaseIterable {
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
    
    case equal
    case sum
    case difference
    case multiplication
    case division
    
    case memoryIn
    case memoryOut
    
    case comma
    case allClear
    case undo
    case redo
    case signChange
    case percentage
    
    case log
    case ln
    case pow
    
    case sin
    case cos
    case tan
    case cot
    
    case pi
    case e
    case random
    
    var stringRepresentation: String {
        switch self {
        case .zero:
            return "0"
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
            
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
            
        case .log:
            return "log"
        case .ln:
            return "ln"
        case .pow:
            return "xª"
            
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
            
        case .memoryIn:
            return "M+"
        case .memoryOut:
            return "M-"
        }
    }
    
    var isAlternative: Bool {
        switch self {
        case .division, .multiplication, .difference, .sum, .equal:
            return true
        default:
            return false
        }
    }
        
    var relatedOperations: [KeyType]? {
        switch self {
        case .undo:
            return [self, .redo]
        case .sin:
            return [self, .cos, .tan, .cot]
        case .log:
            return [self, .ln]
        case .pi:
            return [self, .e, .random]
        default:
            return nil
        }
    }
}
