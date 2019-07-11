//
//  Double+Extension.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/11/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension Double {
    var roundedString: String {
        if floor(self) == self {
            return String(format: "%.0f", self)
        }
        
        return "\(self)"
    }
}
