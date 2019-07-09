//
//  OperationType.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/26/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

enum OperationType: Equatable {
    
    case numeric(Double)
    case constant(Double)
    case unary((Double) -> Double)
    case binary((Double, Double) -> Double)
    case equals
    case other
    
    var canRepeat: Bool {
        if case .constant = self {
            return false
        }
        
        if case .binary = self {
            return false
        }
        
        if case .equals = self {
            return false
        }
        
        return true
    }
    
    static func == (lhs: OperationType, rhs: OperationType) -> Bool {
        if case .numeric = lhs, case .numeric = rhs {
            return true
        }
        
        if case .constant = lhs, case .constant = rhs {
            return true
        }
        
        if case .unary = lhs, case .unary = rhs {
            return true
        }
        
        if case .binary = lhs, case .binary = rhs {
            return true
        }
        
        if case .equals = lhs, case .equals = rhs {
            return true
        }
        
        if case .other = lhs, case .other = rhs {
            return true
        }
        
        return false
    }
}
