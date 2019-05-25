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
    private var sourceRect: CGRect
    private var currentSelectedButton: Button?

    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.popoverPresentationDelegate = PopoverTransitioningDelegate()

        self.stackView = UIStackView()
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.axis = .horizontal
        
        self.sourceRect = .zero
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(sourceRect: CGRect, buttonTypes: [KeyType]) {
        self.init()
        
        self.sourceRect = sourceRect
        
        self.transitioningDelegate = self.popoverPresentationDelegate
        self.modalPresentationStyle = .custom
        
        self.setupView(for: buttonTypes)
        
        self.view.addSubview(stackView)
        self.stackView.constraint(edgesTo: self.view)

        let contentSize = self.stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.preferredContentSize = contentSize
        
        self.popoverPresentationDelegate.sourceRect = sourceRect
        self.popoverPresentationDelegate.contentSize = contentSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(for buttonTypes: [KeyType]) {
        for type in buttonTypes {
            let button = Button()
            button.operation = type
            button.isSelected = type == buttonTypes.first
            
            if type == buttonTypes.first {
                self.currentSelectedButton = button
            }
            
            self.stackView.addArrangedSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: self.sourceRect.height).isActive = true
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: self.sourceRect.width).isActive = true
        }
    }
    
    // MARK: - Button highlight
    
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

        buttons.forEach { button in
            button.isSelected = button == selectedButton
        }
    }
}
