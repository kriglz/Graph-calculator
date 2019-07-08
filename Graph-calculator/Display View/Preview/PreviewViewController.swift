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
    
    convenience init(with view: DisplayView.Label) {
        self.init()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.close(_:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
       
        let frame = CGRect(origin: CGPoint(x: view.frame.origin.x, y: view.frame.origin.y + self.view.frame.origin.y), size: view.bounds.size)
        
        let scrollView = UIScrollView(frame: frame)
        scrollView.backgroundColor = view.backgroundColor
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        
        let shadowView = UIView(frame: frame)
        shadowView.backgroundColor = view.backgroundColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 5
        
        let cornerRadius: CGFloat = 8
        scrollView.layer.cornerRadius = cornerRadius
        shadowView.layer.cornerRadius = cornerRadius
        
        self.view.addSubview(shadowView)
        self.view.addSubview(scrollView)

        scrollView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        self.transitionDelegate.duration = 0.4
        self.transitionDelegate.transitionAnimation = {
            view.sizeToFit()
            
            let viewContentHeight = view.bounds.size.height
            let maxAllowedHeight = self.view.frame.height * 0.3
            scrollView.frame.size.height = viewContentHeight < maxAllowedHeight ? viewContentHeight : maxAllowedHeight
            
            shadowView.frame = scrollView.frame
            shadowView.layer.shadowOpacity = 0.2
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
