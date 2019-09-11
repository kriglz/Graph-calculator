//
//  Brain+AngleUnit.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/18/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension CalculatorBrain {
    enum AngleUnit {
        case radian
        case degree
        
        var multiplier: Double {
            return self == .degree ? Double.pi / 180 : 1
        }
    }
}
