//
//  OperationType.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/26/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

enum OperationType {
    
    case numeric(Int)
    case constant(Double)
    case unary((Double) -> Double)
    case binary((Double, Double) -> Double)
    case equals
    case other
}
