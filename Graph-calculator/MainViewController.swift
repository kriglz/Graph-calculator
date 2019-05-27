//
//  MainViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, KeypadViewDelegate {

    private let keypadView: KeypadView
    private let displayView: DisplayView
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent 
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.keypadView = KeypadView()
        self.displayView = DisplayView()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.keypadView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.18, green: 0.184, blue: 0.188, alpha: 1)

        self.view.addSubview(self.keypadView)
        self.view.addSubview(self.displayView)
        
        self.keypadView.translatesAutoresizingMaskIntoConstraints = false
        self.displayView.translatesAutoresizingMaskIntoConstraints = false
        
       self.makeConstraints()
    }

    private func makeConstraints() {        
        self.displayView.leadingAnchor.constraint(equalTo: self.keypadView.leadingAnchor).isActive = true
        self.displayView.trailingAnchor.constraint(equalTo: self.keypadView.trailingAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.displayView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.displayView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        }
        self.displayView.bottomAnchor.constraint(equalTo: self.keypadView.topAnchor).with(priority: .required).isActive = true
        
        self.keypadView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.97).isActive = true
        self.keypadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.keypadView.topAnchor.constraint(equalTo: self.displayView.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.keypadView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            self.keypadView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
    }
    
    // MARK: - KeypadViewDelegate
    
    func keypadView(_ view: KeypadView, didSelect keyOperation: KeyType) {
        print(keyOperation)
    }
    
    func keypadView(_ view: KeypadView, didSelectPresent popoverViewController: UIViewController) {
        self.present(popoverViewController, animated: false, completion: nil)
    }
    
    func keypadView(_ view: KeypadView, didDeselect popoverViewController: UIViewController) {
        popoverViewController.dismiss(animated: false, completion: nil)
    }
}
