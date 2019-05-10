//
//  MainViewController.swift
//  Graph-calculator
//
//  Created by Kristina Gelzinyte on 5/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private let keyPadViewController: KeyPadViewController
    private let displayViewController: UIViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.keyPadViewController = KeyPadViewController()
        self.displayViewController = UIViewController()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0.173, green: 0.22, blue: 0.27, alpha: 1)
        
        self.addChild(self.keyPadViewController)
        self.addChild(self.displayViewController)
        
        self.view.addSubview(self.keyPadViewController.view)
        self.view.addSubview(self.displayViewController.view)
        
        self.keyPadViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.displayViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
       self.makeConstraints()
    }

    private func makeConstraints() {        
        self.displayViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.displayViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        if #available(iOS 11.0, *) {
            self.displayViewController.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.displayViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        }
        self.displayViewController.view.bottomAnchor.constraint(equalTo: self.keyPadViewController.view.topAnchor).with(priority: .required).isActive = true
        
        self.keyPadViewController.view.leadingAnchor.constraint(equalTo: self.displayViewController.view.leadingAnchor).isActive = true
        self.keyPadViewController.view.trailingAnchor.constraint(equalTo: self.displayViewController.view.trailingAnchor).isActive = true
        
        self.keyPadViewController.view.topAnchor.constraint(equalTo: self.displayViewController.view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.keyPadViewController.view.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            self.keyPadViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
