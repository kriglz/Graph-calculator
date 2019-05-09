//
//  UIView+Extension.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//


import UIKit

extension UIView {
    public func constraint(edgesTo view: UIView, constant: CGFloat = 0) {
        var constraints = [NSLayoutConstraint]()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            constraints.append(self.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constant))
            constraints.append(self.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constant))
            constraints.append(self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant))
            constraints.append(self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant))
        } else {
            constraints.append(self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant))
            constraints.append(self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant))
            constraints.append(self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant))
            constraints.append(self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
