//
//  PopoverBackgroundView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PopoverBackgroundView: UIPopoverBackgroundView {
    
    override class func arrowBase() -> CGFloat {
        return 0
    }
    
    override class func arrowHeight() -> CGFloat {
        return 0
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return .down
        }
        set {}
    }
    
    override var arrowOffset: CGFloat {
        get {
            return 0
        }
        set {}
    }
    
    override class var wantsDefaultContentAppearance: Bool {
        return false
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowColor = UIColor.clear.cgColor
        self.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        layer.path = UIBezierPath.superellipse(in: rect, cornerRadius: 4).cgPath
        layer.lineWidth = 0.5
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.highlightColor.cgColor
        
        self.layer.addSublayer(layer)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
