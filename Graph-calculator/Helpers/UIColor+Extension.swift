//  UIColor+Extension.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/16/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit
    
extension UIColor {

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
}
