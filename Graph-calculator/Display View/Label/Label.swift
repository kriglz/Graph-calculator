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
        static private let titleKey = "DisplayViewLabelTitle"
        static private let originKey = "DisplayViewOriginKey"
        
        var title: String?
        
        var color: UIColor? {
            didSet {
                guard let color = self.color else {
                    return
                }
                
                self.textColor = color
            }
        }
        
        var absoluteOrigin: CGPoint {
            get {
                return self.origin ?? CGPoint(x: self.frame.origin.x + (self.superview?.frame.origin.x ?? 0),
                                              y: self.frame.origin.y + (self.superview?.frame.origin.y ?? 0))
            }
            set {
                self.origin = newValue
            }
        }
        
        var isTruncated: Bool {
            guard let text = self.text else {
                return false
            }
            
            return self.maximumTextLength < text.count
        }
        
        var maximumTextLength: Int {
            let testLabel = UILabel()
            testLabel.text = "99999"
            
            var testLabelHight: CGFloat = 0
            
            while self.bounds.height >= testLabelHight {
                testLabel.text!.append("9")
                testLabelHight = (testLabel.text?.boundingRect(with: CGSize(width: self.bounds.width,
                                                                            height: .greatestFiniteMagnitude),
                                                               options: .usesLineFragmentOrigin,
                                                               attributes: [.font: self.font!],
                                                               context: nil).size.height ?? 0).rounded()
            }
            
            return testLabel.text!.count - 1
        }
        
        private var origin: CGPoint?
        
        convenience init(title: String? = nil, fontSize: CGFloat, color: UIColor? = nil) {
            self.init()
            
            self.title = title
            self.font = UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)
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
            let text = aDecoder.decodeObject(forKey: Label.textKey)
            let frame = aDecoder.decodeCGRect(forKey: Label.frameKey)
            let absoluteOrigin = aDecoder.decodeCGPoint(forKey: Label.originKey)
            let title = aDecoder.decodeObject(forKey: Label.titleKey)
            let font = aDecoder.decodeObject(forKey: Label.fontKey)

            self.text = text as? String
            self.frame = frame
            self.textColor = color as? UIColor
            self.title = title as? String
            self.font = font as? UIFont
            self.absoluteOrigin = absoluteOrigin
        }
        
        override func encode(with aCoder: NSCoder) {
            aCoder.encode(self.textColor, forKey: Label.textColorKey)
            aCoder.encode(self.font, forKey: Label.fontKey)
            aCoder.encode(self.absoluteOrigin, forKey: Label.originKey)
            aCoder.encode(self.text, forKey: Label.textKey)
            aCoder.encode(self.frame, forKey: Label.frameKey)
            
            if let title = self.title {
                aCoder.encode(title, forKey: Label.titleKey)
            }
        }
    }
}
