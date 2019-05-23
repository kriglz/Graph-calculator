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
        let size = CGSize(width: self.contentSize.width + self.sourceRect.width, height: self.contentSize.height + self.sourceRect.height)
        return CGRect(origin: self.sourceRect.origin, size: size)
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverPresentationAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverPresentationAnimationController()
    }
}

class PopoverPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView

        toViewController.view.backgroundColor = .red
        toViewController.view.alpha = 0.5
        
        containerView.addSubview(toViewController.view)
    }
}


