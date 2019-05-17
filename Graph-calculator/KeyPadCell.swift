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

    var operation: KeyType = .zero {
        didSet {
            self.titleLabel.text = self.operation.stringRepresentation
            self.updateHeighlighted(false)
        }
    }
    
    // MARK: - Private properties
    
    private let cardLayer: CAShapeLayer
    private let titleLabel: UILabel
    private var relatedSelectionPopoverViewController: PopoverViewController?

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.cardLayer = CAShapeLayer()
        
        self.titleLabel = UILabel()
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = .white
        
        super.init(frame: frame)
        
        let rect = CGRect(origin: .zero, size: frame.size)
        self.cardLayer.path = UIBezierPath.superellipse(in: rect, cornerRadius: 4).cgPath
        self.cardLayer.frame = rect
        self.cardLayer.lineWidth = 0.5

        self.updateHeighlighted(false)
        
        self.layer.addSublayer(cardLayer)

        self.addSubview(self.titleLabel)

        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showRelatedSelection(_:)))
        longPressGestureRecognizer.minimumPressDuration = 0
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Appearance

    private func updateHeighlighted(_ heighlighted: Bool) {
        if heighlighted {
            self.cardLayer.fillColor = UIColor.highlightColor.cgColor
            self.cardLayer.strokeColor = UIColor.white.cgColor
        } else {
            self.cardLayer.fillColor = self.operation.isAlternative ? UIColor.alternativeKeyColor.cgColor : UIColor.keyColor.cgColor
            self.cardLayer.strokeColor = UIColor.keyBorderColor.cgColor
        }
    }
    
    // MARK: - Actions
    
    @objc func showRelatedSelection(_ sender: Any?) {
        guard let gestureRecognizer = sender as? UILongPressGestureRecognizer else {
            return
        }

        switch gestureRecognizer.state {
        case .began:
            self.scaleDown()
            self.updateHeighlighted(true)

            guard let relatedOperation = self.operation.relatedOperations else {
                return
            }
            
            if self.relatedSelectionPopoverViewController == nil {
                let rect = CGRect(origin: .zero, size: self.frame.size)
                self.relatedSelectionPopoverViewController = PopoverViewController(popoverSourceView: self, sourceRect: rect)
                self.relatedSelectionPopoverViewController?.buttonTypes = relatedOperation
            }
            
            self.delegate?.keyPadCell(self, didSelectPresentPopover: self.relatedSelectionPopoverViewController!)
            
        case .ended, .failed, .cancelled:
            print(gestureRecognizer.location(in: relatedSelectionPopoverViewController?.view))
            
            self.resetScale()
            self.updateHeighlighted(false)

            if let relatedSelectionPopoverViewController = self.relatedSelectionPopoverViewController {
                self.delegate?.keyPadCell(self, didDeselect: relatedSelectionPopoverViewController)
                self.relatedSelectionPopoverViewController = nil
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
