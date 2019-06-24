//
//  Popover+Button.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/18/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

extension PopoverViewController {
    class Button: UIView {
        
        // MARK: - Public properties
        
        var operation: KeyType = .zero {
            didSet {
                self.label.text = self.operation.stringRepresentation
            }
        }
        
        var isSelected: Bool = false {
            didSet {
                self.updateAppearance()
            }
        }
        
        // MARK: - Private properties
        
        private let label: UILabel
        private let backgroundView: UIView
        private let backgroundLayer: CAShapeLayer
        
        // MARK: - Initialization
        
        override init(frame: CGRect) {
            self.label = UILabel()
            self.label.textAlignment = .center

            self.backgroundView = UIView()
            self.backgroundLayer = CAShapeLayer()
            
            super.init(frame: frame)
            
            self.backgroundView.layer.addSublayer(self.backgroundLayer)
            
            self.addSubview(backgroundView)
            self.addSubview(self.label)
            
            self.label.constraint(edgesTo: self)

            self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
            
            self.backgroundView.centerXAnchor.constraint(equalTo: self.label.centerXAnchor).isActive = true
            self.backgroundView.centerYAnchor.constraint(equalTo: self.label.centerYAnchor).isActive = true
            
            self.backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
            self.backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65).isActive = true
            
            self.updateAppearance()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Layout
        
        override func layoutSubviews() {
            super.layoutSubviews()

            let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.backgroundView.bounds.size)
            self.backgroundLayer.path = UIBezierPath.superellipse(in: rect, cornerRadius: 4).cgPath
        }
        
        // MARK: - Contains
        
        func contains(_ point: CGPoint) -> Bool {
            var rect = self.frame
            rect.size.height *= 2
            
            return rect.contains(point)
        }
        
        // MARK: - Appearance
        
        private func updateAppearance() {
            self.label.textColor = self.isSelected ? UIColor(r: 20, g: 55, b: 63, alpha: 1) : .white
            self.backgroundLayer.fillColor = self.isSelected ? UIColor(r: 234, g: 241, b: 243, alpha: 1).cgColor : UIColor.clear.cgColor
        }
    }
}
