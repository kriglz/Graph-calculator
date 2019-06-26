//
//  Keypad.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/17/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class Keypad {
    
    static var dataSource: [KeyType] {
        return [.allClear,      .undo,      .redo,          .memoryIn,      .memoryOut,
                .sqrt,          .pi,        .lParenthesis,  .rParenthesis,  .percentage,
                .pow,           .seven,     .eight,         .nine,          .multiplication,
                .sin,           .four,      .five,          .six,           .difference,
                .sinh,          .one,       .two,           .three,         .sum,
                .log,           .zero,      .comma,         .signChange,    .equal]
    }
    
    struct Operation {
        
        let operation: KeyType
        let operationType: OperationType
        let relatedOperations: [KeyType]?
        let description: String
        
        init(number type: KeyType) {
            self.init(operation: type, operationType: .numeric(type.rawValue), description: "\(type.rawValue)")
        }
        
        init(operation: KeyType, operationType: OperationType, relatedOperations: [KeyType]? = nil, description: String) {
            self.operation = operation
            self.operationType = operationType
            self.relatedOperations = relatedOperations
            self.description = description
        }
    }
    
    enum OperationType {
        
        case numeric(Int)
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        case other
    }
    
    static var masterList: Dictionary<KeyType, Operation> {
        return [
            .pi: Operation(operation: .pi, operationType: .constant(Double.pi), relatedOperations: [.pi, .e, .rand], description: "π"),
            .e: Operation(operation: .e, operationType: .constant(M_E), description: "e"),
            .rand: Operation(operation: .rand, operationType: .constant(Double.random(in: -1000...1000)), description: "rand"),
            
            .sqrt: Operation(operation: .sqrt, operationType: .unary(sqrt), relatedOperations: [.sqrt, .sqrtN], description: "√"),
            .sqrtN: Operation(operation: .sqrtN, operationType: .unary(sqrt), description: "ⁿ√"),
            
            .pow: Operation(operation: .pow, operationType: .binary({ pow($0, $1)}), relatedOperations: [.pow, .powN, .expN], description: "x²"),
            .powN: Operation(operation: .pow, operationType: .binary({ pow($0, $1)}), description: "xⁿ"),
            .expN: Operation(operation: .pow, operationType: .unary(exp), description: "xⁿ"),
            
            .sin: Operation(operation: .sin, operationType: .unary(sin), relatedOperations: [.sin, .cos, .tan], description: "sin"),
            .cos: Operation(operation: .cos, operationType: .unary(cos), description: "cos"),
            .tan: Operation(operation: .tan, operationType: .unary(tan), description: "tan"),
            
            .sinh: Operation(operation: .sinh, operationType: .unary(sinh), relatedOperations: [.sinh, .cosh, .tanh], description: "sinh"),
            .cosh: Operation(operation: .cosh, operationType: .unary(cosh), description: "cosh"),
            .tanh: Operation(operation: .tanh, operationType: .unary(tanh), description: "tanh"),
            
            .log: Operation(operation: .log, operationType: .unary(log), relatedOperations: [.log, .ln], description: "log"),
            .ln: Operation(operation: .ln, operationType: .unary(log), description: "ln"),
            
            .signChange: Operation(operation: .signChange, operationType: .unary({ -$0}), description: "±"),
            .percentage: Operation(operation: .percentage, operationType: .unary({ $0 / 100}), description: "％"),
            
            .sum: Operation(operation: .sum, operationType: .binary({ $0 + $1}), description: "+"),
            .difference: Operation(operation: .difference, operationType: .binary({ $0 - $1}), description: "-"),
            .multiplication: Operation(operation: .multiplication, operationType: .binary({ $0 * $1}), description: "×"),
            .division: Operation(operation: .division, operationType: .binary({ $0 / $1}), description: "÷"),
            
            .equal: Operation(operation: .equal, operationType: .equals, description: "="),
            
            .zero: Operation(number: .zero),
            .one: Operation(number: .one),
            .two: Operation(number: .two),
            .three: Operation(number: .three),
            .four: Operation(number: .four),
            .five: Operation(number: .five),
            .six: Operation(number: .six),
            .seven: Operation(number: .seven),
            .eight: Operation(number: .eight),
            .nine: Operation(number: .nine),
            
            .memoryIn: Operation(operation: .memoryIn, operationType: .other, description: "M+"),
            .memoryOut: Operation(operation: .memoryOut, operationType: .other, description: "M-"),
            
            .lParenthesis: Operation(operation: .lParenthesis, operationType: .other, description: "("),
            .rParenthesis: Operation(operation: .rParenthesis, operationType: .other, description: ")"),
            
            .comma: Operation(operation: .comma, operationType: .other, description: "."),
            .allClear: Operation(operation: .allClear, operationType: .other, description: "AC"),
            .undo: Operation(operation: .undo, operationType: .other, description: "↩︎"),
            .redo: Operation(operation: .redo, operationType: .other, description: "↪︎"),
        ]
    }
}
