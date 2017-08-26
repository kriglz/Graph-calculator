//
//  GraphViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 8/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        
//        if let graphViewController = destinationViewController as? GraphViewController {
//            let identifier = segue.identifier
//    }
    }
 

}
