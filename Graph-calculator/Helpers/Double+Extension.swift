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
        if self == 0 {
            return 1
        }
        
        if self.rounded() != self {
            return Double.nan
        }
        
        if self > Double(Int.max) {
            return Double.nan
        }
        
        let value = Int(self)
        var result = NSDecimalNumber(value: 1)
        
        let range: ClosedRange = self < 0 ? (value...(-1)) : (1...value)
        for i in range.reversed() {
            let behavior = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 17, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
            result = result.multiplying(by: NSDecimalNumber(value: i), withBehavior: behavior)
        }
        
        return result.doubleValue
    }
    
    func rounded(to decimalPlaces: Int) -> Double {
        let multiplier = pow(10.0, Double(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
}
