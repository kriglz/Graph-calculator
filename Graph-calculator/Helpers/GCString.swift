//
//  GCString.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/23/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

struct GCString {
    typealias Attributes = Dictionary<Style, NSRange>
    
    enum Style {
        case superscripted
        case subscripted
    }
    
    let string: String
    let attributes: Attributes?
    
    init() {
        self.string = ""
        self.attributes = nil
    }
    
    init(_ string: String, attributes: Attributes? = nil) {
        self.string = string
        self.attributes = attributes
    }
    
    static func +(lhs: GCString, rhs: GCString) -> GCString {
        let attributes: Attributes?
        if lhs.attributes == nil, rhs.attributes == nil {
            attributes = nil
        } else if lhs.attributes != nil, rhs.attributes == nil {
            attributes = lhs.attributes
        } else if lhs.attributes == nil, rhs.attributes != nil {
            attributes = rhs.attributes
        } else {
            attributes = lhs.attributes!.merging(rhs.attributes!) { _, new in new }
        }
        
        return GCString(lhs.string + rhs.string, attributes: attributes)
    }
}
