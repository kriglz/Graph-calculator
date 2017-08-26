//
//  ViewController.swift
//  calculator
//
//  Created by Kristina Gelzinyte on 5/19/17.
//
//

import UIKit

class CalculatorViewController: UIViewController {

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
    
    private var memory = CalculatorMemory()
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
    
    private var brain = CalculatorBrain()
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
}

