//
//  GraphViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 8/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
//    override func viewDidLoad() {
//    }
    
    
    @IBOutlet weak var graphView: Graph! {
        didSet {
            graphView.y = yResult!(0.0)
//            print(y, "gvc")
        }
   
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var yResult: ((_ xArgument: Double) -> Double)?
    
//    var y = Graph().y //Double?
    
    
//    var memory: [String: Double]?
//    var brain: CalculatorBrain?
    



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







