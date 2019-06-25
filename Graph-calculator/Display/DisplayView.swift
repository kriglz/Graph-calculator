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
    
    private let entryLabel: Label
    private let descriptionLabel: Label
    private let memoryLabel: Label
    
    private var userIsInTheMiddleOfTyping = false
    
    private var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return true
        }
    }
    
    override init(frame: CGRect) {
        self.entryLabel = Label(fontSize: 40)
        self.entryLabel.text = "123"
        
        self.descriptionLabel = Label(fontSize: 40)
        self.descriptionLabel.text = "1+123"

        self.memoryLabel = Label(fontSize: 20)
        self.memoryLabel.text = "12"
        
        super.init(frame: frame)
        
        self.entryLabel.color = GCColor.title(forDarkMode: self.isDarkMode)
        self.descriptionLabel.color = GCColor.subtitle(forDarkMode: self.isDarkMode)
        self.memoryLabel.color = GCColor.footnote(forDarkMode: self.isDarkMode)
        
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
            
            self.textAlignment = .right
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
