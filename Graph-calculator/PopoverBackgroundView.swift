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
        return 5
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
        
        let rect = CGRect(origin: CGPoint(x: 0, y: -5), size: frame.size)
        let elipse = CGPath(roundedRect: rect, cornerWidth: 4, cornerHeight: 4, transform: nil)
        let layer = CAShapeLayer()
        layer.path = elipse
        layer.lineWidth = 0
        layer.fillColor = UIColor(red: 0.4, green: 0.47, blue: 0.482, alpha: 1).cgColor
        
        self.layer.addSublayer(layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
