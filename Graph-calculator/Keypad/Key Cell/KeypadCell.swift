//
//  KeypadCell.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

protocol KeypadCellDelegate: class {
    func keypadCell(_ cell: KeypadCell, didSelectPresentPopover popoverViewController: UIViewController)
    func keypadCell(_ cell: KeypadCell, didDeselect popoverViewController: UIViewController)
    func keypadCell(_ cell: KeypadCell, didSelect keyOperation: KeyType)
}

class KeypadCell: UICollectionViewCell {
    
    // MARK: - Public properties

    static let identifier = "KeyPadCollectionViewCellIdentifier"
    
    weak var delegate: KeypadCellDelegate?

    var operation: KeyType = .zero {
        didSet {
            self.titleLabel.text = self.operation.stringRepresentation
            self.setupAppearance()
        }
    }
    
    // MARK: - Private properties
    
    private let cardLayer: CAShapeLayer
    private let titleLabel: UILabel
    private var relatedSelectionPopoverViewController: PopoverViewController?

    private var isKeyHighlighted: Bool = false {
        didSet {
            self.updateAppearance()
        }
    }
    
    private var hasDefaultBackground: Bool {
        switch self.operation {
        case .allClear, .undo, .redo, .memoryIn, .memoryOut:
            return false
        default:
            return true
        }
    }
    
    private var fillColor: CGColor {
        if self.isKeyHighlighted {
            return UIColor.highlightColor.cgColor
        }

        guard self.hasDefaultBackground else {
            return UIColor.clear.cgColor
        }
        
        switch operation {
        case .division, .multiplication, .difference, .sum, .equal, .percentage:
            return UIColor(red: 0.31, green: 0.424, blue: 0.443, alpha: 1).cgColor
        default:
            return UIColor.keyColor.cgColor
        }
    }
    
    private var strokeColor: CGColor {
        guard self.hasDefaultBackground else {
            return UIColor.clear.cgColor
        }

        return (self.isKeyHighlighted ? UIColor.white.cgColor : UIColor.keyBorderColor.cgColor)
    }
    
    private var textColor: UIColor {
        return self.isKeyHighlighted || self.hasDefaultBackground ? .white : UIColor(red: 0.444, green: 0.584, blue: 0.6, alpha: 1)
    }

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        self.cardLayer = CAShapeLayer()
        
        self.titleLabel = UILabel()
        self.titleLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        let rect = CGRect(origin: .zero, size: frame.size)
        self.cardLayer.path = UIBezierPath.superellipse(in: rect, cornerRadius: 4).cgPath
        self.cardLayer.frame = rect
        
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

    private func setupAppearance() {
        self.updateAppearance()

        if self.hasDefaultBackground {
            self.cardLayer.strokeColor = self.strokeColor
            self.cardLayer.lineWidth = 0.5
            
            return
        }
        
        self.cardLayer.lineWidth = 0
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        
        self.titleLabel.shadowOffset = .zero
        self.titleLabel.shadowColor = UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 0.5)
    }
    
    private func updateAppearance() {
        self.cardLayer.fillColor = self.fillColor
        self.cardLayer.strokeColor = self.strokeColor
        self.titleLabel.textColor = self.textColor
    }
    
    // MARK: - Actions
    
    @objc func showRelatedSelection(_ sender: Any?) {
        guard let gestureRecognizer = sender as? UILongPressGestureRecognizer else {
            return
        }

        switch gestureRecognizer.state {
        case .began:
            self.scaleDown()
            self.isKeyHighlighted = true

            guard let relatedOperation = self.operation.relatedOperations else {
                return
            }
            
            if self.relatedSelectionPopoverViewController == nil {
                self.relatedSelectionPopoverViewController = PopoverViewController(sourceView: self, buttonTypes: relatedOperation)
            }
            
            self.delegate?.keypadCell(self, didSelectPresentPopover: self.relatedSelectionPopoverViewController!)
            
        case .changed:
            guard let keyView = self.relatedSelectionPopoverViewController?.view else {
                return
            }
            
            let location = gestureRecognizer.location(in: keyView)
            self.relatedSelectionPopoverViewController?.selectButton(at: location)

        case .ended, .failed, .cancelled:
            self.resetScale()
            self.isKeyHighlighted = false

            if let currentOperation = self.relatedSelectionPopoverViewController?.currentOperation {
                self.delegate?.keypadCell(self, didSelect: currentOperation)
            } else {
                self.delegate?.keypadCell(self, didSelect: self.operation)
            }

            if let relatedSelectionPopoverViewController = self.relatedSelectionPopoverViewController {
                self.delegate?.keypadCell(self, didDeselect: relatedSelectionPopoverViewController)
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
