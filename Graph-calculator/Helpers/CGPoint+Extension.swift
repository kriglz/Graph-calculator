//
//  CGPoint+Extension.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/27/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        let x = self.x - point.x
        let y = self.y - point.y
        return sqrt(pow(x, 2) + pow(y, 2))
    }
}
