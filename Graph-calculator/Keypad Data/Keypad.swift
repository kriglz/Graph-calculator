//
//  Keypad.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/17/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class Keypad {
    
    static var displayKeyList: [KeyType] {
        return [.allClear,      .undo,      .radians,       .variableX,     .graph,
                .sqrt,          .factorial, .pi,            .memoryPlus,    .division,
                .pow,           .seven,     .eight,         .nine,          .multiplication,
                .sin,           .four,      .five,          .six,           .difference,
                .sinh,          .one,       .two,           .three,         .sum,
                .log,           .zero,      .comma,         .signChange,    .equal]
    }
    
    static var keyList: Dictionary<KeyType, Key> {
        return [
            .pi: Key(keyType: .pi, operationType: .constant(Double.pi), relatedKeyTypes: [.pi, .e, .rand], description: "π"),
            .e: Key(keyType: .e, operationType: .constant(M_E), description: "e"),
            .rand: Key(keyType: .rand, operationType: .constant(Double.random(in: -1000...1000)), description: "rand"),
            
            .sqrt: Key(keyType: .sqrt, operationType: .unary(sqrt), relatedKeyTypes: [.sqrt, .sqrtN], description: "√"),
            .sqrtN: Key(keyType: .sqrtN, operationType: .unary(sqrt), description: "ⁿ√"),
            
            .pow: Key(keyType: .pow, operationType: .binary({ pow($0, $1)}), relatedKeyTypes: [.pow, .powN, .expN], description: "x²"),
            .powN: Key(keyType: .pow, operationType: .binary({ pow($0, $1)}), description: "xⁿ"),
            .expN: Key(keyType: .pow, operationType: .unary(exp), description: "eˣ"),
            
            .sin: Key(keyType: .sin, operationType: .unary(sin), relatedKeyTypes: [.sin, .cos, .tan], description: "sin"),
            .cos: Key(keyType: .cos, operationType: .unary(cos), description: "cos"),
            .tan: Key(keyType: .tan, operationType: .unary(tan), description: "tan"),
            
            .sinh: Key(keyType: .sinh, operationType: .unary(sinh), relatedKeyTypes: [.sinh, .cosh, .tanh], description: "sinh"),
            .cosh: Key(keyType: .cosh, operationType: .unary(cosh), description: "cosh"),
            .tanh: Key(keyType: .tanh, operationType: .unary(tanh), description: "tanh"),
            
            .log: Key(keyType: .log, operationType: .unary(log), relatedKeyTypes: [.log, .ln, .logY], description: "log"),
            .ln: Key(keyType: .ln, operationType: .unary(log), description: "ln"),
            .logY: Key(keyType: .logY, operationType: .unary(log), description: "logʸ"),

            .signChange: Key(keyType: .signChange, operationType: .unary({ -$0}), description: "±"),
            .percentage: Key(keyType: .percentage, operationType: .unary({ $0 / 100}), description: "％"),
            .factorial: Key(keyType: .factorial, operationType: .unary({ $0 / 100}), relatedKeyTypes: [.factorial, .percentage], description: "x!"),

            .sum: Key(keyType: .sum, operationType: .binary({ $0 + $1}), description: "+"),
            .difference: Key(keyType: .difference, operationType: .binary({ $0 - $1}), description: "-"),
            .multiplication: Key(keyType: .multiplication, operationType: .binary({ $0 * $1}), description: "×"),
            .division: Key(keyType: .division, operationType: .binary({ $0 / $1}), description: "÷"),
            
            .equal: Key(keyType: .equal, operationType: .equals, description: "="),
            
            .zero: Key(number: .zero),
            .one: Key(number: .one),
            .two: Key(number: .two),
            .three: Key(number: .three),
            .four: Key(number: .four),
            .five: Key(number: .five),
            .six: Key(number: .six),
            .seven: Key(number: .seven),
            .eight: Key(number: .eight),
            .nine: Key(number: .nine),
            
            .memoryPlus: Key(keyType: .memoryPlus, operationType: .other, relatedKeyTypes: [.memoryPlus, .memoryMinus, .memoryRetain, .memoryClear], description: "m+"),
            .memoryMinus: Key(keyType: .memoryMinus, operationType: .other, description: "m-"),
            .memoryClear: Key(keyType: .memoryClear, operationType: .other, description: "mc"),
            .memoryRetain: Key(keyType: .memoryRetain, operationType: .other, description: "mr"),

            .comma: Key(keyType: .comma, operationType: .other, description: "."),
            .allClear: Key(keyType: .allClear, operationType: .other, description: "AC"),
            .clear: Key(keyType: .clear, operationType: .other, description: "C"),
            .undo: Key(keyType: .undo, operationType: .other, description: "↩︎"),
            .graph: Key(keyType: .graph, operationType: .other, description: "G"),
            
            .degrees: Key(keyType: .degrees, operationType: .other, description: "deg"),
            .radians: Key(keyType: .radians, operationType: .other, description: "rad"),

            .variableX: Key(keyType: .variableX, operationType: .other, description: "x")
        ]
    }
}

//extension UILabel {
//
//    func superscripted(in ranges: [NSRange]) -> NSAttributedString {
//        guard let text = self.text else {
//            return NSAttributedString()
//        }
//
//        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: self.font!])
//        ranges.forEach {
//            attributedString.setAttributes([.baselineOffset: -self.font.pointSize * 0.5], range: $0)
//        }
//
//        return attributedString
//    }
//}
