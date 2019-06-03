//
//  DisplayView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/26/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class DisplayView: UIView {
    
    func enterOperation(_ operation: KeyType) {
        let value = operation.stringRepresentation
        
        guard self.userIsInTheMiddleOfTyping, let textCurrentlyDisplayed = self.entryLabel.text else {
            self.entryLabel.text = value
            self.userIsInTheMiddleOfTyping = true
            return
        }
        
        if let text = self.entryLabel.text, text.contains(".") {
            return
        }
        
        if value == "." {
            return
        }
        
        self.entryLabel.text = textCurrentlyDisplayed + value
    }
    
    var entryValue: Double {
        get {
            if let textValue = self.entryLabel.text {
                return Double(textValue) ?? 0
            }
            return 0
        } set {
            self.entryLabel.text = String(newValue)
        }
    }
    
    private let entryLabel: UILabel
    private let descriptionLabel: UILabel
    private let memoryLabel: UILabel
    
    private var userIsInTheMiddleOfTyping = false
    
    override init(frame: CGRect) {
        self.entryLabel = Label(fontSize: 40, color: .white)
        self.entryLabel.text = "123"
        
        let descriptionLabelColor = UIColor(red: 0.514, green: 0.514, blue: 0.514, alpha: 1)
        self.descriptionLabel = Label(fontSize: 40, color: descriptionLabelColor)
        self.descriptionLabel.text = "1+123"

        let memoryLabelColor = UIColor(red: 0.502, green: 0.533, blue: 0.537, alpha: 1)
        self.memoryLabel = Label(fontSize: 20, color: memoryLabelColor)
        self.memoryLabel.text = "12"
        
        super.init(frame: frame)
        
        let topLayoutGuide = UILayoutGuide()
        let centerTopLayoutGuide = UILayoutGuide()
        let centerBottomLayoutGuide = UILayoutGuide()
        let bottomLayoutGuide = UILayoutGuide()
        
        self.addLayoutGuide(topLayoutGuide)
        self.addLayoutGuide(centerTopLayoutGuide)
        self.addLayoutGuide(centerBottomLayoutGuide)
        self.addLayoutGuide(bottomLayoutGuide)
        
        self.addSubview(self.entryLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.memoryLabel)
        
        self.entryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.memoryLabel.translatesAutoresizingMaskIntoConstraints = false

        centerBottomLayoutGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        centerTopLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor).isActive = true
        bottomLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor, multiplier: 1.5).isActive = true
        topLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        topLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        topLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        self.entryLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.entryLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        self.descriptionLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        self.memoryLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.memoryLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        topLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLayoutGuide.bottomAnchor.constraint(equalTo: self.entryLabel.topAnchor).isActive = true
        
        self.entryLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        self.entryLabel.bottomAnchor.constraint(equalTo: centerTopLayoutGuide.topAnchor).isActive = true
        
        centerTopLayoutGuide.topAnchor.constraint(equalTo: self.entryLabel.bottomAnchor).isActive = true
        centerTopLayoutGuide.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: centerTopLayoutGuide.bottomAnchor).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: centerBottomLayoutGuide.topAnchor).isActive = true
       
        centerBottomLayoutGuide.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor).isActive = true
        centerBottomLayoutGuide.bottomAnchor.constraint(equalTo: self.memoryLabel.topAnchor).isActive = true
        
        self.memoryLabel.topAnchor.constraint(equalTo: centerBottomLayoutGuide.bottomAnchor).isActive = true
        self.memoryLabel.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        bottomLayoutGuide.topAnchor.constraint(equalTo: self.memoryLabel.bottomAnchor).isActive = true
        bottomLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class Label: UILabel {
        convenience init(fontSize: CGFloat, color: UIColor) {
            self.init()
            
            self.font = UIFont.systemFont(ofSize: fontSize)
            self.textColor = color
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            self.textAlignment = .right
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
