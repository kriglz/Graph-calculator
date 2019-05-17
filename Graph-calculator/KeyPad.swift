//
//  KeyPad.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/17/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class KeyPad {
    
    static var dataSource: [KeyType] {
        return [.allClear,      .undo,      .memoryIn,  .memoryOut,     .division,
                .pi,            .seven,     .eight,     .nine,          .multiplication,
                .sin,           .four,      .five,      .six,           .difference,
                .log,           .one,       .two,       .three,         .sum,
                .pow,           .zero,      .signChange,.comma,         .equal]
    }
}
