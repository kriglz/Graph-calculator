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
    
    var backgroundMaskedView: UIImageView? {
        didSet {
            guard let view = self.backgroundMaskedView else {
                return
            }
            
            self.addSubview(view)
            view.mask = self.shapeView
            self.shapeView.frame = self.frame
            
            shapeView.layer.shadowOffset = CGSize(width: 0, height: 1)
            shapeView.layer.shadowOpacity = 0.3
            shapeView.layer.shadowRadius = 1
        }
    }
    
    // MARK: - Private properties
    
    private let shapeView = UIImageView(image: UIImage(named: "ButtonShape"))
    
    private lazy var alternativeSelectionPopoverViewController: UIViewController = {
        let controller = UIViewController()
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label.text = "Hello"
        controller.view.addSubview(label)
        
        controller.view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 50, height: 50)
        
        let popover = controller.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = self
        popover?.sourceRect = self.bounds
        popover?.permittedArrowDirections = .down
        
        return controller
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showAlternativeSelection(_:)))
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
            self.delegate?.keyPadCell(self, didSelectPresentPopover: self.alternativeSelectionPopoverViewController)
        case .ended, .failed, .cancelled:
            self.resetScale()
            self.delegate?.keyPadCell(self, didDeselect: self.alternativeSelectionPopoverViewController)
        default:
            break
        }
    }
    
    // MARK: - Events
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.scaleDown()

        // long touch should generate impact also show alternative selections
//        let generator = UIImpactFeedbackGenerator(style: .light)
//        generator.prepare()
//        generator.impactOccurred()
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.resetScale()
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
    
    // MARK: - UIPopoverPresentationControllerDelegate implementation
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
