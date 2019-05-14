//
//  PopoverViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var alternativeButtons: [OperationType] = [] {
        didSet {
            for button in self.alternativeButtons {
                let label = UILabel()
                label.text = button.stringRepresentation
                label.textAlignment = .center
                
                label.translatesAutoresizingMaskIntoConstraints = false
                
                label.heightAnchor.constraint(equalToConstant: self.targetSize.height).isActive = true
                label.widthAnchor.constraint(equalToConstant: self.targetSize.width).isActive = true
                
                self.stackView.addArrangedSubview(label)
            }
        }
    }
    
    private let stackView = UIStackView()
    private var targetSize: CGSize = .zero
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.axis = .horizontal
        
        self.view.addSubview(stackView)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.view.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor).isActive = true
        
        self.preferredContentSize = self.stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate implementation
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.popoverBackgroundViewClass = PopoverBackgroundView.self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
