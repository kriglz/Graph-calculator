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
                let operationDescription = Keypad.keyList[self.operation]?.description
                if let description = operationDescription, description == "logy" {
                    let font = UIFont(descriptor: self.label.font.fontDescriptor.withSymbolicTraits(.traitBold)!,
                                      size: self.label.font.pointSize * 0.5)
                    let attributedString = NSMutableAttributedString(string: description)
                    attributedString.setAttributes([.font: font, .baselineOffset: 0], range: NSRange(location: 3, length: 1))
                    
                    self.label.attributedText = attributedString
                } else {
                    self.label.text = operationDescription
                }                
            }
        }
        
        var isSelected: Bool = false {
            didSet {
                self.updateAppearance()
            }
        }
        
        // MARK: - Private properties
        
        private let label: UILabel
        
        // MARK: - Initialization
        
        override init(frame: CGRect) {
            self.label = UILabel()
            self.label.textAlignment = .center

            super.init(frame: frame)
            
            self.addSubview(self.label)
            self.label.translatesAutoresizingMaskIntoConstraints = false
            self.label.constraint(edgesTo: self)

            self.updateAppearance(animated: false)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Contains
        
        func contains(_ point: CGPoint) -> Bool {
            var rect = self.frame
            rect.size.height *= 2
            
            return rect.contains(point)
        }
        
        // MARK: - Appearance
        
        private func updateAppearance(animated: Bool = true) {
            if animated == false {
                self.label.textColor = self.isSelected ? UIColor(r: 20, g: 55, b: 63, alpha: 1) : .white
                return
            }
            
            UIView.transition(with: self.label, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.label.textColor = self.isSelected ? UIColor(r: 20, g: 55, b: 63, alpha: 1) : .white
            }, completion: nil)
        }
    }
}
