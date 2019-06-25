//
//  HighlightView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 6/25/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension PopoverViewController {
    class HighlightView: UIView {
        
        private let highlightLayer: CAShapeLayer
        
        override init(frame: CGRect) {
            self.highlightLayer = CAShapeLayer()
            self.highlightLayer.fillColor = UIColor(r: 234, g: 241, b: 243, alpha: 1).cgColor
            
            super.init(frame: frame)
            
            self.layer.addSublayer(highlightLayer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.bounds.size)
            self.highlightLayer.path = UIBezierPath.superellipse(in: rect, cornerRadius: 4).cgPath
        }
    }
}
