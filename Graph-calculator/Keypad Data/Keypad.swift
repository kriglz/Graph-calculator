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
            .pi: Key(.pi, relatedKeyTypes: [.pi, .e, .rand], description: "π"),
            .e: Key(.e, description: "e"),
            .rand: Key(.rand, description: "rand"),
            
            .sqrt: Key(.sqrt, relatedKeyTypes: [.sqrt, .sqrtN], description: "√"),
            .sqrtN: Key(.sqrtN, description: "ⁿ√"),
            
            .pow: Key(.pow, relatedKeyTypes: [.pow, .powN, .expN], description: "x²"),
            .powN: Key(.powN, description: "xⁿ"),
            .expN: Key(.expN, description: "eˣ"),
            
            .sin: Key(.sin, relatedKeyTypes: [.sin, .cos, .tan], alternativeKeyType: .asin, description: "sin"),
            .cos: Key(.cos, description: "cos"),
            .tan: Key(.tan, description: "tan"),
            
            .asin: Key(.asin, relatedKeyTypes: [.asin, .acos, .atan], alternativeKeyType: .sin, description: "sin-1"),
            .acos: Key(.acos, description: "cos-1"),
            .atan: Key(.atan, description: "tan-1"),
            
            .sinh: Key(.sinh, relatedKeyTypes: [.sinh, .cosh, .tanh], alternativeKeyType: .asinh, description: "sinh"),
            .cosh: Key(.cosh, description: "cosh"),
            .tanh: Key(.tanh, description: "tanh"),
            
            .asinh: Key(.asinh, relatedKeyTypes: [.asinh, .acosh, .atanh], alternativeKeyType: .sinh, description: "sinh-1"),
            .acosh: Key(.acosh, description: "cosh-1"),
            .atanh: Key(.atanh, description: "tanh-1"),
            
            .log10: Key(.log10, relatedKeyTypes: [.log10, .ln, .logy], description: "log₁₀"),
            .ln: Key(.ln, description: "ln"),
            .logy: Key(.logy, description: "logy"),

            .signChange: Key(.signChange, description: "±"),
            .percentage: Key(.percentage, description: "％"),
            .factorial: Key(.factorial, relatedKeyTypes: [.factorial, .percentage], description: "x!"),

            .sum: Key(.sum, description: "+"),
            .difference: Key(.difference, description: "-"),
            .multiplication: Key(.multiplication, description: "×"),
            .division: Key(.division, description: "÷"),
            
            .equal: Key(.equal, description: "="),
            
            .zero: Key(.zero),
            .one: Key(.one),
            .two: Key(.two),
            .three: Key(.three),
            .four: Key(.four),
            .five: Key(.five),
            .six: Key(.six),
            .seven: Key(.seven),
            .eight: Key(.eight),
            .nine: Key(.nine),
            
            .memoryPlus: Key(.memoryPlus, relatedKeyTypes: [.memoryPlus, .memoryMinus], alternativeKeyType: .memoryRetain, description: "m+"),
            .memoryMinus: Key(.memoryMinus, description: "m-"),
            .memoryClear: Key(.memoryClear, description: "mc"),
            .memoryRetain: Key(.memoryRetain, relatedKeyTypes: [.memoryRetain, .memoryClear], alternativeKeyType: .memoryPlus, description: "mr"),

            .comma: Key(.comma, description: "."),
            .allClear: Key(.allClear, description: "AC"),
            .clear: Key(.clear, description: "C"),
            .undo: Key(.undo, description: "↩︎"),
            .graph: Key(.graph, description: "G"),
            
            .degrees: Key(.degrees, description: "Deg"),
            .radians: Key(.radians, description: "Rad"),

            .variableX: Key(.variableX, description: "𝒙")
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
