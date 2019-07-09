//
//  KeyType.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

enum KeyType: Int, Equatable {
    
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
    
    case lParenthesis
    case rParenthesis
    
    case log
    case ln
    
    case pow
    case powN
    case expN
    case sqrt
    case sqrtN
    
    case sin
    case cos
    case tan
    
    case sinh
    case cosh
    case tanh
    
    case pi
    case e
    case rand
    
    var numericValue: Int {
        return self.rawValue
    }
    
    var isNumber: Bool {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            return true
        default:
            return false
        }
    }
}
