//
//  CalculatorController.swift
//  calculator
///Users/rupertwaldron/Documents/calculator_1/calculator
//  Created by Илья Лошкарёв on 18.02.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController {

    let buttonText = [["±", "√", "cos", "sin"],
                      ["7", "8", "9", "÷"],
                      ["4", "5", "6", "*"],
                      ["1", "2", "3", "-"],
                      [".", "0", "=", "+"]]
    var inputLabel: UILabel!
    let emptyText = ""
    
    var inputValue: Double = 0
    var precision: Double = 0
    var hasDecimalPoint = false
    var calc : Calculator = Calculator()
    var opType : OperationType? = nil
    var madeOperations: (Bool, Bool) = (false, false)// entered | pressed = | unary
    
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let navigation = parent as? UINavigationController {
            self.title = "Calculator"
            view.bounds = CGRect(x: 0,
                                 y: navigation.toolbar.bounds.height,
                                 width: view.frame.width,
                                 height: view.frame.height -
                                    navigation.toolbar.bounds.height -
                                    UIApplication.shared.statusBarFrame.size.height)
            edgesForExtendedLayout = .bottom
        }
        formatter.minimumIntegerDigits = 1
        initUI()
    }
    
    func initUI(){
        let buttonSize = CGSize(width: view.bounds.width / CGFloat(buttonText[0].count),
                                height: view.bounds.height / CGFloat(buttonText.count + 1))
        // LABEL
        inputLabel = UILabel(frame: CGRect(origin: view.bounds.origin,
                                      size: CGSize(width: view.bounds.width, height: buttonSize.height)))
        //inputLabel.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        inputLabel.text = emptyText
        inputLabel.textAlignment = .right
        inputLabel.font = UIFont(name: "Menlo-Regular", size: 28)
        view.addSubview(inputLabel)
        // BUTTONS
        for i in 0..<buttonText.count {
            for j in 0..<buttonText[i].count {
                let button = createGridButton(row: i, col: j, of: buttonSize)
                button.backgroundColor = #colorLiteral(red: 0.2086084485, green: 0.498249352, blue: 0.7920735478, alpha: 0.6744883363)
                button.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
                view.addSubview(button)
            }
        }

    }
    
    func createGridButton(row: Int, col: Int, of size: CGSize) -> UIButton {
        let buttonOrigin = CGPoint(x: view.bounds.origin.x + CGFloat(col) * size.width,
                                   y: view.bounds.origin.y + CGFloat(row + 1) * size.height)
        let button = UIButton(type: .system)
        button.frame = CGRect(origin: buttonOrigin, size: size)
        
        if buttonText[row][col] == "." {
            button.setTitle(formatter.decimalSeparator, for: .normal)
        } else {
            button.setTitle(buttonText[row][col], for: .normal)
        }
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        button.titleLabel?.font = inputLabel.font.withSize(32)
        return button
    }
    
    func makeCalculation(_ op : OperationType) {
        do {
        switch op {
            case .plus:
                try calc += inputValue
            case .minus:
                calc -= inputValue
            case .mod:
                calc *= inputValue
            case .div:
                try calc /= inputValue
            case .sqrt :
                try √calc
            case .plusMinus:
                ±calc
            case .sin:
                sin(calc)
            case .cos:
                cos(calc)
            }
        } catch MyErrors.divideByZero(let errorMessage) {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch MyErrors.tooLongNumb(let errorMessage) {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch MyErrors.negativeNumber(let errorMessage) {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    catch {
            let alert = UIAlertController(title: "SomeThing Strange", message: ":)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            inputLabel.text = String(calc.result)
        

    }
    
    func printNumber(fracCnt fc: Int, _ d: Double) {
        formatter.minimumFractionDigits = fc
        inputLabel.text = formatter.string(from: NSNumber(value: d))
    }
    
    func printCalculatorResult() {
        let str = String(calc.result)
        let point = str.rangeOfCharacter(from: ["."])?.lowerBound
        printNumber(fracCnt: calc.result.truncatingRemainder(dividingBy: 1.0) < 0.00001 ? 0 : min(str.distance(from: point!, to: str.endIndex) - 1, 5) , calc.result)
    }
    
    func buttonTouched(sender: UIButton)  {
        guard let content = sender.titleLabel?.text else {
            print("No text for touched button")
            return
        }
        switch content {
        case "0"..."9":
            if !madeOperations.0
            {
                madeOperations.0 = true
            }
            
            if madeOperations.0 && opType != nil {
                calc.wasActivated = true
            }
            
            if madeOperations.0 && madeOperations.1 {
                calc.wasActivated = false
            }
            
            if hasDecimalPoint {
                precision *= 10
                inputValue += Double(content)! / precision;
            } else {
                inputValue = inputValue * 10 + Double(content)!
            }

            printNumber(fracCnt: precision <= 1 ? Int(precision) : min(Int(log(precision)/log(10)), 5),inputValue)
            
        case formatter.decimalSeparator:
            if hasDecimalPoint || !madeOperations.0 {
                return
            }
            hasDecimalPoint = true
            precision = 1

            // show point
            print(".")
            
            if inputLabel.text!.isEmpty {
                inputLabel.text = "0" + formatter.decimalSeparator
            } else {
                inputLabel.text = inputLabel.text! + formatter.decimalSeparator
            }
            
        case "-", "+", "*", ":":
            switch content {
            case "-":
                opType = .minus
            case "+":
                opType = .plus
            case "*":
                opType = .mod
            case "÷":
                opType = .div
            default:
                return
            }
            
            madeOperations.1 = false
            hasDecimalPoint = false
            
            if !madeOperations.0 {
                return
            }
            
            if !calc.wasActivated {
                calc.result = inputValue
                print("++", calc.result)
            } else {
                    makeCalculation(opType!)
            }
            
            inputLabel.text = emptyText
            inputValue = 0
            precision = 0
            
        case "√", "±", "sin", "cos" :
            if (!madeOperations.0 && !madeOperations.1) || opType != nil
            {
                return
            }
            
            if !madeOperations.1 && !calc.wasActivated
            {
                calc.result = inputValue
            }

            switch content {
            case "√":
                opType = .sqrt
            case "±":
                opType = .plusMinus
            case "sin":
                opType = .sin
            case "cos":
                opType = .cos
                
            default:
                return
            }
            
            calc.wasActivated = false
            madeOperations.1 = true
            makeCalculation(opType!)
            printCalculatorResult()
            opType = nil
            
            inputValue = 0
            precision = 0

        case "=" :
            
            if madeOperations.0 {
            if let op = opType {
                makeCalculation(op)
            }
            }

            printCalculatorResult()
            madeOperations.0 = false
            madeOperations.1 = true

            calc.wasActivated = true
            hasDecimalPoint = false
            opType = nil
            inputValue = 0
            precision = 0
            
        default:
            print("Unknown button")
        }
    }

}

