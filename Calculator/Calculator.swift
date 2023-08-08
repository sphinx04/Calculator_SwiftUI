//
//  Calculator.swift
//  Calculator
//
//  Created by Sphinx04 on 07.08.23.
//

import Foundation

class Calculator: ObservableObject {

    var buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    @Published var TEXT: String = "0"

    private lazy var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        return formatter
    }()

    private lazy var finalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = "."
        return formatter
    }()

    var styledText: String {
        if TEXT.contains(".") {
            let sequence = TEXT.split(separator: ".")
            let firstPart = sequence.first!
            let lastPart = sequence.count > 1 ? sequence[1] : ""

            let resultFirstPart = finalFormatter.string(from: NSNumber(value: Int(String(firstPart))!)) ?? "Error3"

            print(TEXT)
            return resultFirstPart + "," + lastPart
        }
        if TEXT.contains("e") {
            return TEXT
        }
        return finalFormatter.string(from: NSNumber(value: Int(String(TEXT))!)) ?? "Error4"
    }

    func styleText(_ text: String) -> String {
        guard let number = Double(text) else {
            return "Error"
        }


        if abs(number) == 0.0 {
            return "0"
        } else if abs(number) >= 1e9 {
            let eCount = String(String(Int(number) - 1).count).count
            let str = String(format: "%.\(7 - eCount)e", number)
            let result = str.split(separator: "e").first! + "e" + String(Int(str.split(separator: "e").last!)!)

            return String(result)

        } else if abs(number) <= 1e-8 {

            let eCount = String(String(Int(number) - 1).count).count
            let str = String(format: "%.\(7 - eCount)e", number)

            var firstPart = str.split(separator: "e").first!


            while firstPart.last == "0" || firstPart.last == "." {
                print("firstPart", firstPart)
                firstPart = firstPart.dropLast()
            }

            let lastPart = String(Int(str.split(separator: "e").last!)!)

            let result = firstPart + "e" + lastPart

            return String(result)

        } else {
            let nf = numberFormatter
            nf.maximumFractionDigits = 9 - String(Int(number)).count
            return numberFormatter.string(from: NSNumber(value: number)) ?? "Error1"
        }
    }

    private var isPreresult = false
    private var operand1: Double = 0
    private var operand2: Double = 0
    private var currentOperator: CalcButton?
    private var currentDisplayValue: Double {
        get {
            if TEXT.last == "." {
                return Double(TEXT.dropLast(1)) ?? 0
            }
            return Double(TEXT) ?? 0
        }
        set {
            TEXT = String(newValue)
        }
    }

    func trimText() {
        var tempStr = styleText(TEXT)
        tempStr.remove(at: tempStr.index(before: tempStr.endIndex))
        if tempStr.isEmpty {
            currentDisplayValue = 0.0
            TEXT = "0"
            return
        }
        currentDisplayValue = Double(tempStr) ?? 0.0
        TEXT = styleText(tempStr)
    }

    func trimIfWhole(_ number: Double) -> String {
        let isInt = floor(number) == number
        print("trimmed")
        return isInt ?
        String(Int(number)) :
        String(number)
    }

    func didTap(button: CalcButton) {
        switch button {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            handleNumberInput(button.rawValue)
        case .add, .subtract, .multiply, .divide:
            handleOperatorInput(button)
        case .equal:
            calculateResult()
            isPreresult = false
        case .clear:
            clear()
        case .decimal:
            handleDecimalInput()
        case .percent:
            handlePercentInput()
        case .negative:
            toggleNegative()
        }
    }

    private func handleNumberInput(_ number: String) {
        if TEXT == "0" || isPreresult {
            TEXT = styleText(number)
            isPreresult = false
        } else {
            guard TEXT.replacingOccurrences(of: ".", with: "").count < 9 else {
                print(TEXT.replacingOccurrences(of: ".", with: ""))
                return
            }
            TEXT.append(number)
        }
    }

    private func handleOperatorInput(_ operatorButton: CalcButton) {
        if currentOperator != nil && !isPreresult {
            calculateResult()
        }
        isPreresult = true
        operand1 = currentDisplayValue
        currentOperator = operatorButton
        TEXT = styleText(String(currentDisplayValue))
    }
    
    private func calculateResult() {
        guard let operatorButton = currentOperator else {
            TEXT = styleText(String(currentDisplayValue))
            return
        }
        
        operand2 = currentDisplayValue
        var result: Double = 0
        
        switch operatorButton {
        case .add:
            result = operand1 + operand2
        case .subtract:
            result = operand1 - operand2
        case .multiply:
            result = operand1 * operand2
        case .divide:
            if operand2 != 0 {
                result = operand1 / operand2
            } else {
                TEXT = "Error"
                return
            }
        default:
            break
        }
        currentDisplayValue = result
        TEXT = styleText(String(currentDisplayValue))
        currentOperator = nil
    }

    private func clear() {
        operand1 = 0
        operand2 = 0
        currentOperator = nil
        TEXT = "0"
    }

    private func handleDecimalInput() {
        if !isPreresult {
            if !TEXT.contains(".") {
                TEXT.append(".")
            }
        } else {
            TEXT = "0."
            isPreresult = false
        }
    }

    private func handlePercentInput() {
        currentDisplayValue *= 0.01
        TEXT = styleText(String(currentDisplayValue))
    }

    private func toggleNegative() {
        currentDisplayValue = -currentDisplayValue
        TEXT = styleText(String(currentDisplayValue))
    }
}
