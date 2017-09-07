//
//  GraphViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 8/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController {
    
    var yResult: ((_ xArgument: Double) -> Double)?
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.functionY = yResult
            
            let scaleHandler = #selector(graphView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: scaleHandler)
            graphView.addGestureRecognizer(pinchRecognizer)
            
            let panHandler = #selector(graphView.changePosition(byReactingTo:))
            let panRecognizer = UIPanGestureRecognizer(target: graphView, action: panHandler)
            panRecognizer.maximumNumberOfTouches = 1
            panRecognizer.minimumNumberOfTouches = 1
            graphView.addGestureRecognizer(panRecognizer)
            
            let doubleTapHandler = #selector(graphView.resetTheCenterCoordinate(byReactingTo:))
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: doubleTapHandler)
            doubleTapRecognizer.numberOfTapsRequired = 2
            doubleTapRecognizer.numberOfTouchesRequired = 1
            graphView.addGestureRecognizer(doubleTapRecognizer)
        }
    }
    
//    @IBOutlet weak var scrollView: UIScrollView!
    

}

//    @IBOutlet weak var scrollView: UIScrollView! {
//        didSet {
//            scrollView.delegate = self
//            scrollView.minimumZoomScale = 0.5
//            scrollView.maximumZoomScale = 1.5
//            scrollView.contentSize = graphView.frame.size
//            scrollView.addSubview(graphView)
//        }
//    }

//extension GraphViewController: UIScrollViewDelegate {
//    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
//        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
//        
//        self.scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0)
//        
//        return graphView
//    }
//}







