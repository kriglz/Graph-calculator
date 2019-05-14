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
    
    private var alternativeSelectionPopoverViewController: PopoverViewController?
    
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
                self.alternativeSelectionPopoverViewController = PopoverViewController(popoverSourceView: self, sourceRect: self.bounds)
                self.alternativeSelectionPopoverViewController?.alternativeButtons = OperationType.sin.alternativeOperations
            }
            self.delegate?.keyPadCell(self, didSelectPresentPopover: self.alternativeSelectionPopoverViewController!)
            
        case .ended, .failed, .cancelled:
            print(gestureRecognizer.location(in: alternativeSelectionPopoverViewController?.view))
            
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
}
