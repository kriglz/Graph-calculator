//
//  Double+Extension.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/11/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension Double {
    var roundedToIntIfNeededString: String {
        if floor(self) == self {
            return String(format: "%.0f", self)
        }
        
        return "\(self)"
    }
    
    var factorial: Double {
        let value = Int(self)
        var result = NSDecimalNumber(value: 1)
        
        for i in (1...value).reversed() {
            let behavior = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 17, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            result = result.multiplying(by: NSDecimalNumber(value: i), withBehavior: behavior)
        }
        
        return result.doubleValue
    }
}
