//
//  Label.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/27/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension DisplayView {
    class Label: UILabel {
        
        static private let textColorKey = "DisplayViewLabelColor"
        static private let fontKey = "DisplayViewLabelFont"
        static private let textKey = "DisplayViewLabelText"
        static private let frameKey = "DisplayViewLabelFrame"
        
        var color: UIColor? {
            didSet {
                guard let color = self.color else {
                    return
                }
                
                self.textColor = color
            }
        }
        
        convenience init(fontSize: CGFloat, color: UIColor? = nil) {
            self.init()
            
            self.font = UIFont.systemFont(ofSize: fontSize)
            self.textColor = color
            
            self.configureDefaultShadow()
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.lineBreakMode = .byTruncatingHead
            self.textAlignment = .right
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(frame: .zero)
            
            let color = aDecoder.decodeObject(forKey: Label.textColorKey)
            let font = aDecoder.decodeObject(forKey: Label.fontKey)
            let text = aDecoder.decodeObject(forKey: Label.textKey)
            let frame = aDecoder.decodeCGRect(forKey: Label.frameKey)
            
            self.font = font as? UIFont
            self.text = text as? String
            self.frame = frame
            self.textColor = color as? UIColor
        }
        
        override func encode(with aCoder: NSCoder) {
            aCoder.encode(self.textColor, forKey: Label.textColorKey)
            aCoder.encode(self.font, forKey: Label.fontKey)
            aCoder.encode(self.text, forKey: Label.textKey)
            aCoder.encode(self.frame, forKey: Label.frameKey)
        }
    }
}
