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
    
    weak var calculatorVC: CalculatorViewController? = nil
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let calculatorVC = calculatorVC {
            calculatorVC.memory.storage?.removeValue(forKey: "x")
        }
    }
}








