//
//  Brain+OperandValue.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/18/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension CalculatorBrain {
    enum OperandValue {
        case numeric(Double)
        case nonNumeric(String)
    }
}
