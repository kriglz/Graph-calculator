//
//  MainSplitViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 8/27/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
