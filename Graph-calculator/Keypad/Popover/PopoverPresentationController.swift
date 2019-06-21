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
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.highlightColor.cgColor
        
        self.containerView?.layer.insertSublayer(layer, at: 0)
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
