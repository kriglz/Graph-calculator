//
//  NSLayoutConstraint.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> Self {
        self.priority = priority
        
        return self
    }
    
    func with(constant: CGFloat) -> Self {
        self.constant = constant
        
        return self
    }
}
