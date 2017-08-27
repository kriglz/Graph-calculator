//
//  GraphViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 8/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var functionToGraph: String? = nil
    
    override func viewDidLoad() {
        if functionToGraph != nil {
            // send functionToGraph to the draw view
            
            let graph = Graph()
            graph.function = functionToGraph!
        }
    }
    
    @IBOutlet weak var drawView: Graph!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
    }
    


}


    



