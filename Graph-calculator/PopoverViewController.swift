//
//  PopoverViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/14/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var alternativeButtons: [KeyPadViewController.Operation] = [] {
        didSet {
            for button in self.alternativeButtons {
                let label = UILabel()
                label.textColor = .white
                label.text = button.stringRepresentation
                label.textAlignment = .center
                
                self.stackView.addArrangedSubview(label)

                label.translatesAutoresizingMaskIntoConstraints = false
                label.heightAnchor.constraint(greaterThanOrEqualToConstant: self.targetSize.height).isActive = true
                label.widthAnchor.constraint(greaterThanOrEqualToConstant: self.targetSize.width).isActive = true
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
        
        let spacing: CGFloat = 0
        let horizontalSpacing: CGFloat = 0
        self.stackView.spacing = spacing
        self.stackView.isLayoutMarginsRelativeArrangement = true
        self.stackView.layoutMargins = UIEdgeInsets(top: horizontalSpacing, left: spacing, bottom: horizontalSpacing, right: spacing)
        
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
    
    // MARK: - UIPopoverPresentationControllerDelegate implementation
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.popoverBackgroundViewClass = PopoverBackgroundView.self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
