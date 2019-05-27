//
//  DisplayView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/26/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class DisplayView: UIView {
    
    private let entryLabel: UILabel
    private let descriptionLabel: UILabel
    private let memoryLabel: UILabel
    
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
        
        self.addSubview(self.entryLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.memoryLabel)
        
        self.entryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.memoryLabel.translatesAutoresizingMaskIntoConstraints = false

        self.entryLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 33).isActive = true
        self.entryLabel.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor, constant: -18).with(priority: .defaultHigh).isActive = true
        self.entryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.entryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: self.entryLabel.bottomAnchor, constant: 18).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.memoryLabel.topAnchor, constant: -18).with(priority: .defaultHigh).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
        self.memoryLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 18).isActive = true
        self.memoryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.memoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.memoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
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
