//
//  PreviewTransitionControllerDelegate.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 7/5/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class PreviewTransitionControllerDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var originFrame = CGRect.zero
    var animation: (() -> Void)?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewPresentationAnimationController(duration: 0.5, originFrame: self.originFrame, animation: animation)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}
