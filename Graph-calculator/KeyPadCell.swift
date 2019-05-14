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
                self.alternativeSelectionPopoverViewController = ButtonStackViewController(popoverSourceView: self, sourceRect: self.bounds)
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

class ButtonStackViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let buttonStack = UIStackView()
    
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
        
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        buttonStack.axis = .horizontal
        
        let first = UILabel()
        first.text = "First"
        
        let second = UILabel()
        second.text = "Second"
        
        first.translatesAutoresizingMaskIntoConstraints = false
        second.translatesAutoresizingMaskIntoConstraints = false
        
        first.heightAnchor.constraint(equalToConstant: self.targetSize.height).isActive = true
        first.widthAnchor.constraint(equalToConstant: self.targetSize.width).isActive = true
        
        second.heightAnchor.constraint(equalToConstant: self.targetSize.height).isActive = true
        second.widthAnchor.constraint(equalToConstant: self.targetSize.width).isActive = true
        
        buttonStack.addArrangedSubview(first)
        buttonStack.addArrangedSubview(second)
        
        self.view.addSubview(buttonStack)
        
        self.buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
    
        
        self.buttonStack.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.buttonStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.view.bottomAnchor.constraint(equalTo: self.buttonStack.bottomAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.buttonStack.trailingAnchor).isActive = true
        
        self.preferredContentSize = self.buttonStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
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
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowColor = UIColor.clear.cgColor
        self.backgroundColor = .clear
        
        let rect = CGRect(origin: .zero, size: frame.size)
        let elipse = CGPath(roundedRect: rect, cornerWidth: 4, cornerHeight: 4, transform: nil)
        let layer = CAShapeLayer()
        layer.path = elipse
        layer.lineWidth = 1
        layer.strokeColor = UIColor.blue.cgColor
        layer.fillColor = UIColor.blue.cgColor

        self.layer.addSublayer(layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
