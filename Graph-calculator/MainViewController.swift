//
//  MainViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, KeypadViewDelegate {
    
    private var calculator: Calculator
    private let keypadView: KeypadView
    private let displayView: DisplayView
    
    private var isDarkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        } else {
            return true
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.calculator = Calculator()
        self.keypadView = KeypadView()
        self.displayView = DisplayView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.calculator.delegate = self
        self.keypadView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if #available(iOS 13.0, *) {
//            self.overrideUserInterfaceStyle = .dark
//        }

        self.view.backgroundColor = GCColor.background(forDarkMode: self.isDarkMode)

        self.view.addSubview(self.keypadView)
        self.view.addSubview(self.displayView)
        
        self.keypadView.translatesAutoresizingMaskIntoConstraints = false
        self.displayView.translatesAutoresizingMaskIntoConstraints = false
        
        self.makeConstraints()
        
        self.registerForPreviewing(with: self, sourceView: self.displayView)
    }

    private func makeConstraints() {
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
        self.calculator.setOperand(keyOperation)
    }
    
    func keypadView(_ view: KeypadView, didSelectPresent popoverViewController: UIViewController) {
        self.present(popoverViewController, animated: false, completion: nil)
    }
    
    func keypadView(_ view: KeypadView, didDeselect popoverViewController: UIViewController) {
        popoverViewController.dismiss(animated: false, completion: nil)
    }
}

extension MainViewController: CalculatorDelegate {
    func calculator(_ calculator: Calculator, didUpdateLastOperation operation: String) {
        self.displayView.currentOperationText = operation
    }
    
    func calculator(_ calculator: Calculator, didUpdateDescription description: String) {
        self.displayView.descriptionText = description
    }
    
    func calculator(_ calculator: Calculator, didUpdateMemory memory: String) {
        self.displayView.memoryText = memory
    }
}

extension MainViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let popViewController = UIViewController()
        popViewController.view.backgroundColor = GCColor.background(forDarkMode: self.isDarkMode)
        
        let view = self.displayView.subview(at: location)

        popViewController.view.addSubview(view)
        
        let margin: CGFloat = 20
        view.constraint(edgesTo: popViewController.view, constant: margin)

        popViewController.preferredContentSize = CGSize(width: view.bounds.size.width, height: view.bounds.size.height + margin * 2)
        previewingContext.sourceRect = view.frame
        
        return popViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        return
    }
}
