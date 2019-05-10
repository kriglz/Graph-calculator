//
//  KeyPadCell.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

protocol KeyPadCellDelegate: class {
    func keyPadCell(_ cell: KeyPadCell, didSelectPresentPopover popoverViewController: UIViewController)
    func keyPadCell(_ cell: KeyPadCell, didDeselect popoverViewController: UIViewController)
}

class KeyPadCell: UICollectionViewCell, UIPopoverPresentationControllerDelegate {
    
    // MARK: - Public properties

    static let identifier = "KeyPadCollectionViewCellIdentifier"
    
    weak var delegate: KeyPadCellDelegate?
    
    // MARK: - Private properties
    
    private var alternativeSelectionPopoverViewController: UIViewController?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let shapeView = UIImageView(image: UIImage(named: "ButtonShape"))
        self.addSubview(shapeView)
        shapeView.constraint(edgesTo: self)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showAlternativeSelection(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func showAlternativeSelection(_ sender: Any?) {
        guard let gestureRecognizer = sender as? UILongPressGestureRecognizer else {
            return
        }

        switch gestureRecognizer.state {
        case .began:
            self.scaleDown()

            if self.alternativeSelectionPopoverViewController == nil {
                self.alternativeSelectionPopoverViewController = self.setuoAlternativeSelectionPopoverViewController()
            }
            self.delegate?.keyPadCell(self, didSelectPresentPopover: self.alternativeSelectionPopoverViewController!)
            
        case .ended, .failed, .cancelled:
            self.resetScale()

            if let alternativeSelectionPopoverViewController = self.alternativeSelectionPopoverViewController {
                self.delegate?.keyPadCell(self, didDeselect: alternativeSelectionPopoverViewController)
                self.alternativeSelectionPopoverViewController = nil
            }
        default:
            break
        }
    }
    
    // MARK: - Animation
    
    private func scaleDown() {
        UIView.animate(withDuration: 0.03) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func resetScale() {
        UIView.animate(withDuration: 0.07) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Selection controller
    
    private func setuoAlternativeSelectionPopoverViewController() -> UIViewController {
        let controller = UIViewController()
        
//        let buttonStack = UIStackView()
//        buttonStack.alignment = .fill
//        buttonStack.distribution = .fillEqually
//        buttonStack.axis = .horizontal
        
        let first = UIButton(type: .system)
        first.titleLabel?.text = "First"
        
//        let second = UIButton(frame: self.bounds)
//        second.titleLabel?.text = "Second"
//
//        buttonStack.addArrangedSubview(first)
//        buttonStack.addArrangedSubview(second)
        
        controller.view.addSubview(first)
        first.constraint(edgesTo: controller.view)
        
        controller.view.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 100, height: 50)
        
        let popover = controller.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = self
        popover?.sourceRect = self.bounds
        popover?.permittedArrowDirections = .down
        
        return controller
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate implementation
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.popoverBackgroundViewClass = PopoverBackground.self
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

class PopoverBackground: UIPopoverBackgroundView {
    
    override class func arrowBase() -> CGFloat {
        return 0
    }
    
    override class func arrowHeight() -> CGFloat {
        return 0
    }
    
    override var arrowDirection: UIPopoverArrowDirection {
        get {
            return .down
        }
        set {}
    }
    
    override var arrowOffset: CGFloat {
        get {
            return 0
        }
        set {}
    }
    
    override class var wantsDefaultContentAppearance : Bool {
        return true
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowColor = UIColor.clear.cgColor
        self.backgroundColor = .red
        
//        let rect = CGRect(origin: .zero, size: frame.size)
//        let elipse = CGPath(ellipseIn: rect, transform: nil)
//        let layer = CAShapeLayer()
//        layer.path = elipse
//        layer.lineWidth = 2
//        layer.strokeColor = UIColor.blue.cgColor
//
//        self.layer.addSublayer(layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
