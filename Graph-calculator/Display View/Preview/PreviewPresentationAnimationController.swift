//
//  PreviewPresentationAnimationController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/5/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PreviewPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: TimeInterval?
    private var transitionAnimation: (() -> Void)?
    
    convenience init(duration: TimeInterval? = nil, transitionAnimation: (() -> Void)? = nil) {
        self.init()
        
        self.duration = duration
        self.transitionAnimation = transitionAnimation
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: self.duration ?? 0,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.01,
                       options: [.allowUserInteraction, .curveEaseIn, .beginFromCurrentState],
                       animations: {
                            self.transitionAnimation?()
                       },
                       completion: nil)
    }
}
