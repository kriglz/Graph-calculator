//
//  PreviewPresentationAnimationController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/5/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PreviewPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: TimeInterval = 0.5
    private var transitionFrame: CGRect = .zero
    private var animation: (() -> Void)?
    
    convenience init(duration: TimeInterval, originFrame: CGRect, animation: (() -> Void)? = nil) {
        self.init()
        
        self.duration = duration
        self.transitionFrame = originFrame
        self.animation = animation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        //        toViewController.view.frame = self.transitionFrame
        containerView.addSubview(toViewController.view)
        
        
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: [.allowUserInteraction, .curveEaseIn],
                               animations: {
                                    self.animation?()
                               }, completion: { completed in
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                               })
        
    }
}
