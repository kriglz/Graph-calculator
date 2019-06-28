//
//  DisplayView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/26/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class DisplayView: UIView {
    
    var currentOperationText: String = "" {
        didSet {
            self.currentOperationLabel.text = self.currentOperationText
        }
    }
    
    var descriptionText: String = "" {
        didSet {
            self.descriptionLabel.text = self.descriptionText
        }
    }
    
    var memoryText: String = "" {
        didSet {
            self.memoryLabel.text = self.memoryText
        }
    }
    
    private let currentOperationLabel: Label
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
        self.currentOperationLabel = Label(fontSize: 40)
        self.currentOperationLabel.text = "123"
        
        self.descriptionLabel = Label(fontSize: 40)
        self.descriptionLabel.text = "1+123"

        self.memoryLabel = Label(fontSize: 20)
        self.memoryLabel.text = "12"
        
        super.init(frame: frame)
        
        self.currentOperationLabel.color = GCColor.title(forDarkMode: self.isDarkMode)
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
        
        self.addSubview(self.currentOperationLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.memoryLabel)
        
        self.currentOperationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.memoryLabel.translatesAutoresizingMaskIntoConstraints = false

        centerBottomLayoutGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        centerTopLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor).isActive = true
        bottomLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor, multiplier: 1.5).isActive = true
        topLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        topLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        topLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        
        self.currentOperationLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.currentOperationLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        self.descriptionLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        self.memoryLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.memoryLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        topLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLayoutGuide.bottomAnchor.constraint(equalTo: self.currentOperationLabel.topAnchor).isActive = true
        
        self.currentOperationLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        self.currentOperationLabel.bottomAnchor.constraint(equalTo: centerTopLayoutGuide.topAnchor).isActive = true
        
        centerTopLayoutGuide.topAnchor.constraint(equalTo: self.currentOperationLabel.bottomAnchor).isActive = true
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
    
    func subview(at location: CGPoint) -> UIView {
        var distance = CGFloat.greatestFiniteMagnitude
        var targetView = UIView()
        
        for view in self.subviews where view.center.distance(to: location) < distance {
            distance = view.center.distance(to: location)
            targetView = view.copyView()
        }
        
        return targetView
    }
}
