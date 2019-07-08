//
//  PopoverViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    // MARK: - Public properties
    
    var currentOperation: KeyType? {
        return self.currentSelectedButton?.operation
    }
    
    // MARK: - Private properties

    private let popoverPresentationDelegate: PopoverTransitioningDelegate
    private let stackView: UIStackView
    private var highlightView: HighlightView
    private var currentSelectedButton: Button?

    private var activeHighlightViewXPositionConstraints = [NSLayoutConstraint]()
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.popoverPresentationDelegate = PopoverTransitioningDelegate()

        self.stackView = UIStackView()
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.axis = .horizontal
        self.stackView.spacing = 0
        
        self.highlightView = HighlightView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(sourceRect: CGRect, buttonTypes: [KeyType]) {
        self.init()
        
        let length = sourceRect.size.width.rounded() - 1.5
        let buttonSize = CGSize(width: length, height: length)

        self.setupButtonStackView(with: buttonSize, for: buttonTypes)
        
        self.view.addSubview(self.highlightView)
        self.view.addSubview(self.stackView)
        
        self.highlightView.translatesAutoresizingMaskIntoConstraints = false
        
        if let firstButton = self.stackView.arrangedSubviews.first {
            self.highlightView.widthAnchor.constraint(equalTo: firstButton.widthAnchor, multiplier: 0.75).isActive = true
            self.highlightView.heightAnchor.constraint(equalTo: firstButton.heightAnchor, multiplier: 0.65).isActive = true

            self.highlightView.centerYAnchor.constraint(equalTo: firstButton.centerYAnchor).isActive = true
            
            self.moveHighlight(to: firstButton)
        }
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.constraint(edgesTo: self.view)

        let contentSize = self.stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        
        self.popoverPresentationDelegate.sourceRect = sourceRect
        self.popoverPresentationDelegate.contentSize = contentSize
        
        self.transitioningDelegate = self.popoverPresentationDelegate
        self.modalPresentationStyle = .custom
        
        self.selectDefaultButton(for: buttonTypes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonStackView(with size: CGSize, for buttonTypes: [KeyType]) {
        for type in buttonTypes {
            let button = Button()
            button.operation = type
            
            self.stackView.addArrangedSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: size.height).isActive = true
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: size.width).isActive = true
        }
    }

    // MARK: - Layout

    private func moveHighlight(to view: UIView) {
        NSLayoutConstraint.deactivate(self.activeHighlightViewXPositionConstraints)
        self.activeHighlightViewXPositionConstraints.removeAll()
        
        defer {
            NSLayoutConstraint.activate(self.activeHighlightViewXPositionConstraints)
        }
        
        self.activeHighlightViewXPositionConstraints.append(self.highlightView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
    }
    
    // MARK: - Button highlight
    
    func selectDefaultButton(for buttonTypes: [KeyType]) {
        guard let buttons = self.stackView.arrangedSubviews as? [Button], buttons.count > 0, buttonTypes.count > 0 else {
            return
        }
        
        guard let firstButton = buttons.first(where: { $0.operation == buttonTypes[0] }) else {
            return
        }
        
        firstButton.isSelected = true
        self.currentSelectedButton = firstButton
    }
    
    func selectButton(at location: CGPoint) {
        guard let buttons = self.stackView.arrangedSubviews as? [Button] else {
            return
        }

        guard let selectedButton = buttons.first(where: { $0.contains(location)}) else {
            return
        }
        
        if self.currentSelectedButton == selectedButton {
            return
        }

        self.currentSelectedButton = selectedButton

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
            self.moveHighlight(to: selectedButton)
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        buttons.forEach { button in
            button.isSelected = button == selectedButton
        }
    }
}
