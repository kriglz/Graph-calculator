//
//  KeyPad+Types.swift
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
    
    
}

enum OperationType: CaseIterable {
    case sum
    case difference
    case multiplication
    case division
    
    case comma
    
    case sin
    case cos
    case tan
    case cot
    
    var stringRepresentation: String {
        switch self {
        case .sum:
            return "+"
        case .sin:
            return "sin"
        case .cos:
            return "cos"
        case .tan:
            return "tan"
        case .cot:
            return "cot"
        default:
            return "-"
        }
    }
    
    var alternativeOperations: [OperationType] {
        switch self {
        case .sin:
            return [self, .cos, .tan, .cot]
        default:
            return [self]
        }
    }
}
