//
//  ViewController.swift
//  Calculator
//
//  Created by yinghao Sun on 24/06/2015.
//  Copyright (c) 2015 yinghao Sun. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber = false
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        }else{
            display.text=digit
            userIsInTheMiddleOfTypingANumber=true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        switch operation{
        case "×": preformOperation{ $0 * $1 }
        case "÷": preformOperation{ $1 / $0 }
        case "+": preformOperation{ $0 + $1 }
        case "−": preformOperation{ $1 - $0 }
        case "√": preformOperation{ sqrt($0) }
        default: break
        }
    }
    func preformOperation(operation: (Double, Double) -> Double){
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    private func preformOperation(operation: Double -> Double){
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

