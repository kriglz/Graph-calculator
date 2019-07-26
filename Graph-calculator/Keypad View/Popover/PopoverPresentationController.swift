//
//  PopoverPresentationController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/21/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {

    var sourceRect: CGRect = .zero
    var contentSize: CGSize = .zero

    private var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return true
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let origin = CGPoint(x: self.sourceRect.minX, y: self.sourceRect.minY - self.sourceRect.height)
        return CGRect(origin: origin, size: self.contentSize)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath.superellipse(in: self.frameOfPresentedViewInContainerView, cornerRadius: 4).cgPath
        layer.lineWidth = 0.5
        layer.strokeColor = GCColor.popoverBorder(forDarkMode: self.isDarkMode).cgColor
        layer.fillColor = GCColor.highlight(forDarkMode: self.isDarkMode).cgColor
        
        self.containerView?.layer.insertSublayer(layer, at: 0)
        
        self.containerView?.layer.shadowOpacity = 0.3
        self.containerView?.layer.shadowRadius = 4
        self.containerView?.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
}

class PopoverTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var sourceRect: CGRect = .zero
    var contentSize: CGSize = .zero
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PopoverPresentationController(presentedViewController: presented, presenting: presenting)
        controller.sourceRect = self.sourceRect
        controller.contentSize = self.contentSize
        return controller
    }
}
