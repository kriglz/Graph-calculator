//
//  Calculator.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/21/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

struct Calculator {
    
    private var descriptionArray: [String] = []
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<KeyType, Operation> = [
        KeyType.pi: Operation.constant(Double.pi),
        KeyType.e: Operation.constant(M_E),
        KeyType.random: Operation.constant(Double.random(in: -1000...1000)),
        
        KeyType.sqrt: Operation.unaryOperation(sqrt),
        KeyType.sqrtN: Operation.unaryOperation(sqrt),
        
        KeyType.pow: Operation.binaryOperation({ pow($0, $1)}),
        KeyType.pow: Operation.binaryOperation({ pow($0, $1)}),
        KeyType.expN: Operation.unaryOperation(exp),
        
        KeyType.cos: Operation.unaryOperation(cos),
        KeyType.cosh: Operation.unaryOperation(cosh),
        KeyType.sin: Operation.unaryOperation(sin),
        KeyType.sinh: Operation.unaryOperation(sinh),
        KeyType.tan: Operation.unaryOperation(tan),
        KeyType.tanh: Operation.unaryOperation(tanh),
        
        
        KeyType.ln: Operation.unaryOperation(log),
        KeyType.log: Operation.unaryOperation(log),
        
        KeyType.signChange: Operation.unaryOperation({ -$0}),
        KeyType.percentage: Operation.unaryOperation({ $0 / 100}),
        
        KeyType.multiplication: Operation.binaryOperation({ $0 * $1}),
        KeyType.division: Operation.binaryOperation({ $0 / $1}),
        KeyType.sum: Operation.binaryOperation({ $0 + $1}),
        KeyType.difference: Operation.binaryOperation({ $0 - $1}),
        
        KeyType.equal: Operation.equals
    ]
}
