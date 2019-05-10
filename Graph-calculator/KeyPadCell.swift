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
    private var alternativeSelectionPopoverViewController: UIViewController?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate implementation
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
