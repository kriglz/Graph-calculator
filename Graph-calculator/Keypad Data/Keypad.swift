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
                .log10,         .zero,      .comma,         .signChange,    .equal]
    }
    
    static var keyList: Dictionary<KeyType, Key> {
        return [
            .pi: Key(keyType: .pi, relatedKeyTypes: [.pi, .e, .rand], description: "π"),
            .e: Key(keyType: .e, description: "e"),
            .rand: Key(keyType: .rand, description: "rand"),
            
            .sqrt: Key(keyType: .sqrt, relatedKeyTypes: [.sqrt, .sqrtN], description: "√"),
            .sqrtN: Key(keyType: .sqrtN, description: "ⁿ√"),
            
            .pow: Key(keyType: .pow, relatedKeyTypes: [.pow, .powN, .expN], description: "x²"),
            .powN: Key(keyType: .powN, description: "xⁿ"),
            .expN: Key(keyType: .expN, description: "eˣ"),
            
            .sin: Key(keyType: .sin, relatedKeyTypes: [.sin, .cos, .tan], alternativeKeyType: .asin, description: "sin"),
            .cos: Key(keyType: .cos, description: "cos"),
            .tan: Key(keyType: .tan, description: "tan"),
            
            .asin: Key(keyType: .asin, relatedKeyTypes: [.asin, .acos, .atan], alternativeKeyType: .sin, description: "sin-1"),
            .acos: Key(keyType: .acos, description: "cos-1"),
            .atan: Key(keyType: .atan, description: "tan-1"),
            
            .sinh: Key(keyType: .sinh, relatedKeyTypes: [.sinh, .cosh, .tanh], alternativeKeyType: .asinh, description: "sinh"),
            .cosh: Key(keyType: .cosh, description: "cosh"),
            .tanh: Key(keyType: .tanh, description: "tanh"),
            
            .asinh: Key(keyType: .asinh, relatedKeyTypes: [.asinh, .acosh, .atanh], alternativeKeyType: .sinh, description: "sinh-1"),
            .acosh: Key(keyType: .acosh, description: "cosh-1"),
            .atanh: Key(keyType: .atanh, description: "tanh-1"),
            
            .log10: Key(keyType: .log10, relatedKeyTypes: [.log10, .ln, .logY], description: "log10"),
            .ln: Key(keyType: .ln, description: "ln"),
            .logY: Key(keyType: .logY, description: "logʸ"),

            .signChange: Key(keyType: .signChange, description: "±"),
            .percentage: Key(keyType: .percentage, description: "％"),
            .factorial: Key(keyType: .factorial, relatedKeyTypes: [.factorial, .percentage], description: "x!"),

            .sum: Key(keyType: .sum, description: "+"),
            .difference: Key(keyType: .difference, description: "-"),
            .multiplication: Key(keyType: .multiplication, description: "×"),
            .division: Key(keyType: .division, description: "÷"),
            
            .equal: Key(keyType: .equal, description: "="),
            
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
            
            .memoryPlus: Key(keyType: .memoryPlus, relatedKeyTypes: [.memoryPlus, .memoryMinus], alternativeKeyType: .memoryRetain, description: "m+"),
            .memoryMinus: Key(keyType: .memoryMinus, description: "m-"),
            .memoryClear: Key(keyType: .memoryClear, description: "mc"),
            .memoryRetain: Key(keyType: .memoryRetain, relatedKeyTypes: [.memoryRetain, .memoryClear], alternativeKeyType: .memoryPlus, description: "mr"),

            .comma: Key(keyType: .comma, description: "."),
            .allClear: Key(keyType: .allClear, description: "AC"),
            .clear: Key(keyType: .clear, description: "C"),
            .undo: Key(keyType: .undo, description: "↩︎"),
            .graph: Key(keyType: .graph, description: "G"),
            
            .degrees: Key(keyType: .degrees, description: "deg"),
            .radians: Key(keyType: .radians, description: "rad"),

            .variableX: Key(keyType: .variableX, description: "x")
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
