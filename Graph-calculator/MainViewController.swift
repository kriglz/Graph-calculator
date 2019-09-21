//
//  MainViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, KeypadViewDelegate, CalculatorDelegate, DisplayViewDelegate, GraphViewControllerDelegate {
    
    private var calculator: Calculator
    private let keypadView: KeypadView
    private let displayView: DisplayView
    
    private var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            let darkMode = self.traitCollection.userInterfaceStyle == .dark
            AnalyticsManager.shared.appearanceMode(darkMode)
            return darkMode
        } else {
            AnalyticsManager.shared.appearanceMode(false)
            return false
        }
    }
    
    private var graphViewController: GraphViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.calculator = Calculator()
        self.keypadView = KeypadView()
        self.displayView = DisplayView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Calculator"
        
        self.calculator.delegate = self
        self.keypadView.delegate = self
        self.displayView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.keypadView)
        self.view.addSubview(self.displayView)
        
        self.makeConstraints()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.backgroundColor = GCColor.background(forDarkMode: self.isDarkMode)

    }

    private func makeConstraints() {
        self.keypadView.translatesAutoresizingMaskIntoConstraints = false
        self.displayView.translatesAutoresizingMaskIntoConstraints = false
        
        self.keypadView.setContentHuggingPriority(.required, for: .vertical)
        
        self.displayView.leadingAnchor.constraint(equalTo: self.keypadView.leadingAnchor).isActive = true
        self.displayView.trailingAnchor.constraint(equalTo: self.keypadView.trailingAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.displayView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            self.displayView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        }
        self.displayView.bottomAnchor.constraint(equalTo: self.keypadView.topAnchor).with(priority: .required).isActive = true
        
        self.keypadView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.keypadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.keypadView.topAnchor.constraint(equalTo: self.displayView.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.keypadView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        } else {
            self.keypadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        }
    }
    
    // MARK: - KeypadViewDelegate
    
    func keypadView(_ view: KeypadView, didSelect keyOperation: KeyType) {
        if keyOperation == .graph {
            self.calculator.graphData { [weak self] result in
                if case .failure = result {
                    let alert = UIAlertController(title: "Graphing Calculator", message: "Please enter valid function.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(okAction)
                    self?.present(alert, animated: true, completion: nil)
                } else if case .success(let data) = result {
                    guard let self = self else {
                        return
                    }
                    
                    AnalyticsManager.shared.presentGraphSelected()
                    
                    if self.graphViewController == nil {
                        self.graphViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GraphViewController") as? GraphViewController
                    }
                    
                    guard let graphViewController = self.graphViewController else {
                        return
                    }
                    
                    graphViewController.delegate = self
                    graphViewController.view.backgroundColor = GCColor.background(forDarkMode: self.isDarkMode)
                    graphViewController.functionTitle = data.title
                    graphViewController.yResult = data.yFunction
                    
                    self.present(graphViewController, animated: true, completion: nil)
                }
            }
            
            return
        }

        if !self.displayView.canAppendNewOperandsToCurrentOperation, self.calculator.userIsInTheMiddleOfTyping && (keyOperation.isNumber || keyOperation == .comma) {
            return
        }
        
        self.calculator.setOperand(keyOperation)
    }
    
    func keypadView(_ view: KeypadView, didSelectPresent popoverViewController: UIViewController) {
        self.present(popoverViewController, animated: false, completion: nil)
    }
    
    func keypadView(_ view: KeypadView, didDeselect popoverViewController: UIViewController) {
        popoverViewController.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - CalculatorDelegate
    
    func calculator(_ calculator: Calculator, didUpdateLastOperation operation: String) {
        self.displayView.currentOperationText = operation
    }
    
    func calculator(_ calculator: Calculator, didUpdateDescription description: GCStringArray) {
        self.displayView.descriptionText = description
    }
    
    func calculator(_ calculator: Calculator, didUpdateMemory memory: String) {
        self.displayView.memoryText = memory
    }
    
    func calculator(_ calculator: Calculator, isTyping: Bool) {
        self.keypadView.updateKey(isTyping ? .allClear : .clear, with: isTyping ? .clear : .allClear)
    }
    
    func calculator(_ calculator: Calculator, angleUnit: CalculatorBrain.AngleUnit) {
        self.keypadView.updateKey(angleUnit == .degree ? .radians : .degrees, with: angleUnit == .degree ? .degrees : .radians)
    }
    
    // MARK: - DisplayViewDelegate
    
    func displayView(_ view: DisplayView, didSelectPresent viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func displayView(_ view: DisplayView, didSelectClose viewController: UIViewController) {
        viewController.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - GraphViewControllerDelegate
    
    func graphViewControllerDidSelectClose(_ controller: GraphViewController) {
        self.graphViewController?.dismiss(animated: true, completion: {
            self.calculator.resetMemory()
            self.graphViewController = nil
        })
    }
}
