//
//  DisplayView.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/26/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

protocol DisplayViewDelegate: class {
    func displayView(_ view: DisplayView, didSelectPresent viewController: UIViewController)
    func displayView(_ view: DisplayView, didSelectClose viewController: UIViewController)
}

class DisplayView: UIView, PreviewViewControllerDelegate {
    
    // MARK: - Public properties
    
    weak var delegate: DisplayViewDelegate?
    
    var canAppendNewOperandsToCurrentOperation: Bool {
        return self.currentOperationText.count < self.currentOperationLabel.maximumTextLength
    }
    
    var currentOperationText: String = "" {
        didSet {
            if self.currentOperationText.count < self.currentOperationLabel.maximumTextLength {
                self.currentOperationLabel.text = self.currentOperationText
                return
            }
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = self.currentOperationLabel.maximumTextLength
            formatter.decimalSeparator = Keypad.keyList[.comma]!.description

            guard let currentOperation = formatter.string(from: NSNumber(value: Double(self.currentOperationText) ?? 0)) else {
                return
            }
            
            if currentOperation.count < self.currentOperationLabel.maximumTextLength {
                self.currentOperationLabel.text = currentOperation
                return
            }
            
            guard let value = Double(self.currentOperationText) else {
                self.currentOperationLabel.text = "\(Double.nan)"
                return
            }
            
            if value < 1, value > 0 {
                self.currentOperationLabel.text = String(value.rounded(to: self.currentOperationLabel.maximumTextLength - 2))
            }
            
            if value < 0, value > -1 {
                self.currentOperationLabel.text = String(value.rounded(to: self.currentOperationLabel.maximumTextLength - 3))
            }
            
            let digitCount = String(format: "%.0f", value.rounded()).count
            if digitCount >= self.currentOperationLabel.maximumTextLength {
                formatter.numberStyle = .scientific
                formatter.exponentSymbol = "e"
                formatter.maximumFractionDigits -= String(digitCount).count + 2
                self.currentOperationLabel.text = formatter.string(for: NSNumber(value: value)) ?? "\(Double.nan)"
            } else {
                self.currentOperationLabel.text = String(value.rounded(to: self.currentOperationLabel.maximumTextLength - digitCount - 1))
            }
        }
    }
    
    var descriptionText: String = "" {
        didSet {
            self.descriptionLabel.text = self.descriptionText
        }
    }
    
    var memoryText: String = "" {
        didSet {
            self.memoryLabel.text = self.memoryText
        }
    }
    
    // MARK: - Private properties

    private let currentOperationLabel: Label
    private let descriptionLabel: Label
    private let memoryLabel: Label
    
    private var previewViewController: PreviewViewController?
    
    private var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return true
        }
    }
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        self.currentOperationLabel = Label(title: "Current operation", fontSize: 40)
        self.currentOperationLabel.text = "123"
        
        self.descriptionLabel = Label(title: "Description", fontSize: 40)
        self.descriptionLabel.text = "1+123"

        self.memoryLabel = Label(title: "Memory", fontSize: 20)
        self.memoryLabel.text = "12"
        
        super.init(frame: frame)
        
        self.currentOperationLabel.color = GCColor.title(forDarkMode: self.isDarkMode)
        self.descriptionLabel.color = GCColor.subtitle(forDarkMode: self.isDarkMode)
        self.memoryLabel.color = GCColor.footnote(forDarkMode: self.isDarkMode)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openPreview(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        
        self.makeConstrints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeConstrints() {
        let topLayoutGuide = UILayoutGuide()
        let centerTopLayoutGuide = UILayoutGuide()
        let centerBottomLayoutGuide = UILayoutGuide()
        let bottomLayoutGuide = UILayoutGuide()
        
        self.addLayoutGuide(topLayoutGuide)
        self.addLayoutGuide(centerTopLayoutGuide)
        self.addLayoutGuide(centerBottomLayoutGuide)
        self.addLayoutGuide(bottomLayoutGuide)
        
        self.addSubview(self.currentOperationLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.memoryLabel)
        
        self.currentOperationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.memoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        centerBottomLayoutGuide.heightAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        centerTopLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor).isActive = true
        bottomLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor, multiplier: 1.5).isActive = true
        topLayoutGuide.heightAnchor.constraint(equalTo: centerBottomLayoutGuide.heightAnchor, multiplier: 0.1).isActive = true
        
        topLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.currentOperationLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.currentOperationLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        self.descriptionLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.descriptionLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        self.memoryLabel.leadingAnchor.constraint(equalTo: topLayoutGuide.leadingAnchor).isActive = true
        self.memoryLabel.trailingAnchor.constraint(equalTo: topLayoutGuide.trailingAnchor).isActive = true
        
        topLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLayoutGuide.bottomAnchor.constraint(equalTo: self.currentOperationLabel.topAnchor).isActive = true
        
        self.currentOperationLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        self.currentOperationLabel.bottomAnchor.constraint(equalTo: centerTopLayoutGuide.topAnchor).isActive = true
        
        centerTopLayoutGuide.topAnchor.constraint(equalTo: self.currentOperationLabel.bottomAnchor).isActive = true
        centerTopLayoutGuide.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor).isActive = true
        
        self.descriptionLabel.topAnchor.constraint(equalTo: centerTopLayoutGuide.bottomAnchor).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: centerBottomLayoutGuide.topAnchor).isActive = true
        
        centerBottomLayoutGuide.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor).isActive = true
        centerBottomLayoutGuide.bottomAnchor.constraint(equalTo: self.memoryLabel.topAnchor).isActive = true
        
        self.memoryLabel.topAnchor.constraint(equalTo: centerBottomLayoutGuide.bottomAnchor).isActive = true
        self.memoryLabel.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        bottomLayoutGuide.topAnchor.constraint(equalTo: self.memoryLabel.bottomAnchor).isActive = true
        bottomLayoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // MARK: - Subviews

    private func subview(at location: CGPoint) -> Label {
        var distance = CGFloat.greatestFiniteMagnitude
        var targetView = Label()
        
        for view in self.subviews where view.center.distance(to: location) < distance {
            distance = view.center.distance(to: location)
            targetView = view.copyView() as Label
        }
        
        return targetView
    }
    
    // MARK: - Actions

    @objc private func openPreview(_ gesture: UITapGestureRecognizer) {
        let label = self.subview(at: gesture.location(in: self))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = GCColor.previewBackground(forDarkMode: self.isDarkMode)
        
        if self.isDarkMode {
            label.textColor = GCColor.title(forDarkMode: self.isDarkMode)
        }
        
        guard label.isTruncated else {
            return
        }
        
        self.previewViewController = PreviewViewController(with: label)
        self.previewViewController?.delegate = self
        if let previewController = self.previewViewController {
            self.delegate?.displayView(self, didSelectPresent: previewController)
        }
    }
    
    // MARK: - PreviewViewControllerDelegate
    
    func previewViewControllerDidSelectClose(_ viewController: PreviewViewController) {
        if let previewController = self.previewViewController {
            self.delegate?.displayView(self, didSelectClose: previewController)
            self.previewViewController = nil
        }
    }
}
