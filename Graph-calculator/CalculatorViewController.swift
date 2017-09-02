//
//  ViewController.swift
//  calculator
//
//  Created by Kristina Gelzinyte on 5/19/17.
//
//

import UIKit

class CalculatorViewController: UIViewController, UISplitViewControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    @IBOutlet weak var memoryDisplay: UILabel!
    @IBAction func undoButton(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {          //undo characters
            if !(display.text?.characters.isEmpty)! {
                display.text!.characters.removeLast()
                if (display.text?.characters.isEmpty)! {
                    display.text! = "0.0"
                    userIsInTheMiddleOfTyping = false
                }
            }
            if (descriptionDisplay.text?.isEmpty)! {
                descriptionDisplay.text = " "
            }
        } else {                                //undo operations
            brain.undoPreviousOperation()
            displayDescription()
            
            if let result = brain.evaluate(using: memory.storage).result {
                displayValue = result
            }
            displayDescription()
        }
    }
    @IBAction func allClearButton(_ sender: Any) {
        brain.clearAll()
        memory.storage = nil
        memoryDisplay.text! = " "
        displayDescription()
        userIsInTheMiddleOfTyping = false
    }
    @IBAction func randomGenerationButton(_ sender: UIButton) {
        let maxNumber = Double(UInt32.max)
        let randomNumber = Double(arc4random())
        displayValue = randomNumber/maxNumber
        userIsInTheMiddleOfTyping = true

    }

    var userIsInTheMiddleOfTyping = false

    
//
//typing numbers
//
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            if !display.text!.contains(".") || digit != "." {
                let textCurrentlyDisplayed = display.text!
                display.text! = textCurrentlyDisplayed + digit
            }
        } else {
            display.text! = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        } set {
            display.text = String(newValue)
        }
    }

    
    
//
//setting/getting memory
//
    
    var memory = CalculatorMemory()
    @IBAction func setMemory(_ sender: UIButton) {
        memory.storage = ["M": displayValue]
        memoryDisplay.text! = "M → " + String(displayValue)
        userIsInTheMiddleOfTyping = false

        if !brain.description.isEmpty {
            display.text! = String(brain.evaluate(using: memory.storage).result!)
        }

    }
    @IBAction func getMemory(_ sender: UIButton) {
        brain.setOperand(variable: "M")
        displayValue = memory.storage?["M"] ?? 0
    }
    
    
    
    
//
//using/doing operartion
//
    
    var brain = CalculatorBrain()
    @IBAction func mathematicalSymbol(_ sender: UIButton) {
        //set operand
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        //set operation
        if let mathematicalSymbol = sender.currentTitle {
            brain.setOperand(variable: mathematicalSymbol)
        }
    
        //get result
        if let result = brain.evaluate(using: memory.storage).result {
            displayValue = result
        }
        displayDescription()
    }
    
    //adding elipses or equal sign to the description label
    func displayDescription() {
        if brain.evaluate().isPending {
            descriptionDisplay.text! = brain.description + "..."
        } else {
            if !brain.description.isEmpty {
                descriptionDisplay.text! = brain.description + "="
            } else {
                displayValue = 0
                descriptionDisplay.text! = "0"
            }
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = (segue.destination.contents as? GraphViewController) {
            if !brain.description.isEmpty {
                destinationViewController.navigationItem.title = brain.description
                
                destinationViewController.yResult = { (xArgument: Double) -> Double in
                    self.memory.storage = ["M": xArgument]
                    let yResult = self.brain.evaluate(using: self.memory.storage).result!
                    return yResult
                }
            }
            
//            let something   = { (xArgument: Double) -> Double in
//                
//                self.memory.storage = ["M": xArgument]
//                let yResult = self.brain.evaluate(using: self.memory.storage).result!
//                print(yResult)
//                
//                return yResult
//            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let gvc = secondaryViewController.contents as? GraphViewController, gvc.graphView == nil {
                return true
            }
        }
        return false
    }

}

extension UIViewController
{
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
