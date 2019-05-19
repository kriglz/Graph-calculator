//
//  PopoverViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Public properties
    
    var buttonTypes: [KeyType] = [] {
        didSet {
            for type in self.buttonTypes {
                let button = Button()
                button.operation = type
                button.isSelected = type == self.buttonTypes.first
                
                if type == self.buttonTypes.first {
                    self.currentSelectedButton = button
                }
                
                self.stackView.addArrangedSubview(button)

                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(greaterThanOrEqualToConstant: self.targetSize.height).isActive = true
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: self.targetSize.width).isActive = true
            }
        }
    }
    
    var currentOperation: KeyType? {
        return self.currentSelectedButton?.operation
    }
    
    // MARK: - Private properties

    private let stackView = UIStackView()
    private var targetSize: CGSize = .zero
    
    private var currentSelectedButton: Button?
    
    // MARK: - Initialization
    
    convenience init(popoverSourceView: UIView, sourceRect: CGRect) {
        self.init()
        
        self.targetSize = sourceRect.size
        
        self.modalPresentationStyle = .popover
        
        let popover = self.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = popoverSourceView
        popover?.sourceRect = sourceRect
        popover?.permittedArrowDirections = .down
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.axis = .horizontal
        
        self.view.addSubview(stackView)
        self.stackView.constraint(edgesTo: self.view)
        
        self.preferredContentSize = self.stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.popoverPresentationController?.containerView?.subviews.forEach {
            $0.removeFromSuperview()
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
    
    // MARK: - UIPopoverPresentationControllerDelegate implementation
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.popoverBackgroundViewClass = PopoverBackgroundView.self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
