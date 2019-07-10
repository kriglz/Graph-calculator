//
//  GraphViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 8/23/17.
//  Copyright © 2017 Kristina Gelzinyte. All rights reserved.
//

import UIKit

protocol GraphViewControllerDelegate: class {
    func graphViewControllerDidSelectClose(_ controller: GraphViewController)
}

class GraphViewController: UIViewController {
    
    var yResult: ((_ xArgument: Double) -> Double)? {
        didSet {
            self.graphView.functionY = self.yResult
        }
    }
    
    var functionTitle: String = "" {
        didSet {
            self.functionTitleLabel.text = self.functionTitle
        }
    }
    
    weak var delegate: GraphViewControllerDelegate?
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
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
    
    private var functionTitleLabel = UILabel()
    private var cancelButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.functionTitleLabel.numberOfLines = 0
        self.functionTitleLabel.textAlignment = .center
        self.functionTitleLabel.backgroundColor = self.view.backgroundColor
        
        self.cancelButton.setImage(UIImage(named: "CloseIcon"), for: .normal)
        self.cancelButton.addTarget(self, action: #selector(self.close(_:)), for: .touchUpInside)
        
        self.view.addSubview(self.functionTitleLabel)
        self.view.addSubview(self.cancelButton)
        
        self.functionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 10
        
        if #available(iOS 11.0, *) {
            self.functionTitleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
            self.functionTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.67).isActive = true
            self.functionTitleLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -margin).isActive = true
            
            self.cancelButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
            self.cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: margin).isActive = true
        } else {
            self.functionTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            self.functionTitleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
            self.functionTitleLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -margin).isActive = true
            
            self.cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: margin).isActive = true
            self.cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: margin).isActive = true
        }
    }
    
    @objc func close(_ sender: UIButton) {
        self.delegate?.graphViewControllerDidSelectClose(self)
    }
}
