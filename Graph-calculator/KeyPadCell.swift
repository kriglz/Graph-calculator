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

class KeyPadCell: UICollectionViewCell {
    
    // MARK: - Public properties

    static let identifier = "KeyPadCollectionViewCellIdentifier"
    
    weak var delegate: KeyPadCellDelegate?
    
    // MARK: - Private properties
    
    private let cardLayer = CAShapeLayer()
    private var alternativeSelectionPopoverViewController: PopoverViewController?

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect = CGRect(origin: .zero, size: frame.size)
        self.cardLayer.path = UIBezierPath.superellipse(in: rect, cornerRadius: 4).cgPath
        self.cardLayer.frame = rect
        
        self.cardLayer.lineWidth = 0.5
        self.cardLayer.shadowColor = UIColor.white.cgColor
        self.cardLayer.shadowOffset = .zero
        self.cardLayer.shadowRadius = 1
        
        self.updateHeighlighted(false)
        
        self.layer.addSublayer(cardLayer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showAlternativeSelection(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Appearance

    private func updateHeighlighted(_ heighlighted: Bool) {
        if heighlighted {
            self.cardLayer.fillColor = UIColor(red: 0.4, green: 0.47, blue: 0.482, alpha: 1).cgColor
            self.cardLayer.strokeColor = UIColor.clear.cgColor
            self.cardLayer.shadowOpacity = 1
        } else {
            self.cardLayer.fillColor = UIColor(red: 0.38, green: 0.388, blue: 0.388, alpha: 1).cgColor
            self.cardLayer.strokeColor = UIColor(red: 0.588, green: 0.59, blue: 0.59, alpha: 1).cgColor
            self.cardLayer.shadowOpacity = 0
        }
    }
    
    // MARK: - Actions
    
    @objc func showAlternativeSelection(_ sender: Any?) {
        guard let gestureRecognizer = sender as? UILongPressGestureRecognizer else {
            return
        }

        switch gestureRecognizer.state {
        case .began:
            self.scaleDown()
            self.updateHeighlighted(true)

            if self.alternativeSelectionPopoverViewController == nil {
                self.alternativeSelectionPopoverViewController = PopoverViewController(popoverSourceView: self, sourceRect: CGRect(origin: .zero, size: self.frame.size))
                self.alternativeSelectionPopoverViewController?.alternativeButtons = KeyPadViewController.Operation.sin.alternativeOperations
            }
            self.delegate?.keyPadCell(self, didSelectPresentPopover: self.alternativeSelectionPopoverViewController!)
        case .ended, .failed, .cancelled:
            print(gestureRecognizer.location(in: alternativeSelectionPopoverViewController?.view))
            
            self.resetScale()
            self.updateHeighlighted(false)

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
}
