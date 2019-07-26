//
//  PreviewViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/5/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

protocol PreviewViewControllerDelegate: class {
    func previewViewControllerDidSelectClose(_ viewController: PreviewViewController)
}

class PreviewViewController: UIViewController {
    
    weak var delegate: PreviewViewControllerDelegate?
    
    private let transitionDelegate: PreviewTransitionControllerDelegate
    
    private var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return true
        }
    }
    
    convenience init(with label: DisplayView.Label) {
        self.init()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.close(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let frame = CGRect(origin: CGPoint(x: label.absoluteOrigin.x,
                                           y: label.absoluteOrigin.y - self.view.frame.origin.y),
                           size: label.bounds.size)
        
        let scrollView = UIScrollView(frame: frame)
        scrollView.backgroundColor = label.backgroundColor
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        
        let shadowView = UIView(frame: frame)
        shadowView.backgroundColor = label.backgroundColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 5
        
        let cornerRadius: CGFloat = 8
        scrollView.layer.cornerRadius = cornerRadius
        shadowView.layer.cornerRadius = cornerRadius
        
        self.view.addSubview(shadowView)
        self.view.addSubview(scrollView)

        scrollView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        label.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        self.transitionDelegate.duration = 0.4
        self.transitionDelegate.transitionAnimation = {
            self.view.backgroundColor = GCColor.previewOverlay(forDarkMode: self.isDarkMode)

            label.sizeToFit()
            
            let viewContentHeight = label.bounds.size.height
            let maxAllowedHeight = self.view.frame.height * 0.3
            scrollView.frame.size.height = viewContentHeight < maxAllowedHeight ? viewContentHeight : maxAllowedHeight
            
            shadowView.frame = scrollView.frame
            shadowView.layer.shadowOpacity = 0.25
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.transitionDelegate = PreviewTransitionControllerDelegate()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitionDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func close(_ gesture: UITapGestureRecognizer) {
        self.delegate?.previewViewControllerDidSelectClose(self)
    }
}
