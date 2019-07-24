//
//  GCStringArray.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/23/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class GCStringArray {
    
    var endIndex: Int {
        return self.array.endIndex
    }
    
    var startIndex: Int {
        return self.array.startIndex
    }
    
    var count: Int {
        return self.array.count
    }
    
    var elements: [GCString] {
        return self.array
    }
    
    var isEmpty: Bool {
        return self.array.isEmpty
    }
    
    subscript(index: Int) -> GCString {
        get {
            return self.array[index]
        }
        set(newValue) {
            self.array[index] = newValue
        }
    }
    
    private var array: [GCString] = []
    
    init() { }
    
    init(with gcString: GCString) {
        self.array.append(gcString)
    }
    
    static func +(lhs: GCStringArray, rhs: String) -> GCStringArray {
        let array = lhs
        array.append(rhs)
        return array
    }
    
    static func +(lhs: String, rhs: GCStringArray) -> GCStringArray {
        let array = GCStringArray()
        array.append(GCString(lhs))
        array.append(contentsOf: rhs)
        return array
    }
    
    func append(_ gcString: GCString) {
        self.array.append(gcString)
    }
    
    func append(_ string: String) {
        self.array.append(GCString(string))
    }
    
    func append(contentsOf newElements: GCStringArray) {
        self.array.append(contentsOf: newElements.elements)
    }
    
    func index(before i: Int) -> Int {
        return self.array.index(before: i)
    }
    
    func insert(_ newElement: GCString, at i: Int) {
        self.array.insert(newElement, at: i)
    }
    
    func insert(_ newElement: String, at i: Int) {
        self.array.insert(GCString(newElement), at: i)
    }
    
    func attributedDescription(for font: UIFont) -> NSAttributedString {
        let description = NSMutableAttributedString()
        
        self.array.forEach { element in
            var string = NSMutableAttributedString(string: element.string, attributes: [.font: font])
            
            if let attributes = element.attributes {
                attributes.forEach { attribute in
                    if element.string == "𝒙" {
                        string = NSMutableAttributedString(string: "x", attributes: [.font: UIFont(descriptor: font.fontDescriptor.withSymbolicTraits(.traitItalic)!, size: font.pointSize)])
                    }
                    let offset = attribute.key == .superscripted ? font.pointSize * 0.5 : 0
                    
                    string.setAttributes([.font: UIFont(name: font.fontName, size: font.pointSize * 0.5)!,
                                          .baselineOffset: offset], range: attribute.value)
                }
            }
            
            description.append(string)
        }
        
        return description
    }
}
