//
//  PreviewTransitionControllerDelegate.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/5/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PreviewTransitionControllerDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var transitionAnimation: (() -> Void)?
    var duration: TimeInterval?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewPresentationAnimationController(duration: self.duration, transitionAnimation: self.transitionAnimation)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
