//
//  CalculatorController.swift
//  calculator
//
//  Created by Илья Лошкарёв on 18.02.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class CalculatorController: UIViewController {

    let buttonText = [["7", "8", "9", ":"],
                      ["4", "5", "6", "*"],
                      ["1", "2", "3", "-"],
                      ["C", "0", ".", "+"],
                      ["" , "" , "" , "="]]
    var inputLabel: UILabel!
    let emptyText = ""
    
    var inputValue: Double = 0
    var precision: Double = 0
    var hasDecimalPoint = false
    var calc : Calculator = Calculator()
    var opType : OperationType? = nil
    
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
        inputLabel.text = emptyText
        inputLabel.textAlignment = .right
        inputLabel.font = UIFont(name: "Menlo-Regular", size: 28)
        view.addSubview(inputLabel)
        // BUTTONS
        for i in 0..<buttonText.count {
            for j in 0..<buttonText[i].count {
                let button = createGridButton(row: i, col: j, of: buttonSize)
                button.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
                view.addSubview(button)
            }
        }
        calc = calc + 4.0
        calc += 3.4
        print(calc.result)
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
        button.titleLabel?.font = inputLabel.font.withSize(28)
        return button
    }
    
    func buttonTouched(sender: UIButton)  {
        guard let content = sender.titleLabel?.text else {
            print("No text for touched button")
            return
        }
        switch content {
        case "0"..."9":
            if hasDecimalPoint {
                precision *= 10
                inputValue += Double(content)! / precision;
            } else {
                inputValue = inputValue * 10 + Double(content)!
            }
            if precision <= 1 {
                formatter.minimumFractionDigits = Int(precision)
            } else {
                formatter.minimumFractionDigits = min(Int(log(precision)/log(10)), 5)
            }
            inputLabel.text = formatter.string(from: NSNumber(value: inputValue))
        case formatter.decimalSeparator:
            hasDecimalPoint = true
            precision = 1
            // show point
            if inputLabel.text!.isEmpty {
                inputLabel.text = "0" + formatter.decimalSeparator
            } else {
                inputLabel.text = inputLabel.text! + formatter.decimalSeparator
            }
        case "C":
            inputValue = 0
            inputLabel.text = emptyText
            hasDecimalPoint = false
            precision = 0
            
        case "+":
            calc.result = inputValue
            inputValue = 0
            opType = .plus
            inputLabel.text = emptyText
            
        case "=" :
            if let op = opType {
            switch op {
            case .plus:
                calc += inputValue
            default:
                calc -= 3
            }
                inputLabel.text = String(calc.result)
            }
            else {
                print("error _-")
            }
        default:
            print("Unknown button")
        }
    }

}

