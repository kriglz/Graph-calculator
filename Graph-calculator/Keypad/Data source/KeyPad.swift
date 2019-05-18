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
        return [.allClear,      .undo,      .redo,      .memoryIn,      .memoryOut,
                .sqrt,          .pi,        .lParenthesis,.rParenthesis,.percentage,
                .pow,           .seven,     .eight,     .nine,          .multiplication,
                .sin,           .four,      .five,      .six,           .difference,
                .sinh,          .one,       .two,       .three,         .sum,
                .log,           .zero,      .comma,     .signChange,    .equal]
    }
}
