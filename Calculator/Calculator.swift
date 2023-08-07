//
//  Calculator.swift
//  Calculator
//
//  Created by Sphinx04 on 07.08.23.
//

import Foundation

enum Operation {
    case add, subtract, multiply, divide, none
}

class Calculator: ObservableObject {

    var buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    @Published var text: String = "0"
    private var operand1: Double = 0
    private var operand2: Double = 0
    private var currentOperator: CalcButton?
    private var currentDisplayValue: Double {
        get {
            return Double(text) ?? 0
        }
        set {
            text = String(newValue)
        }
    }

    func didTap(button: CalcButton) {
        switch button {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            handleNumberInput(button.rawValue)
        case .add, .subtract, .multiply, .divide:
            handleOperatorInput(button)
        case .equal:
            calculateResult()
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
        if text == "0" {
            text = number
        } else {
            text.append(number)
        }
    }

    private func handleOperatorInput(_ operatorButton: CalcButton) {
        if currentOperator != nil {
            calculateResult()
        }
        operand1 = currentDisplayValue
        currentOperator = operatorButton
        text = "0"
    }

    private func calculateResult() {
        guard let operatorButton = currentOperator else { return }

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
                text = "Error"
                return
            }
        default:
            break
        }

        currentDisplayValue = result
        currentOperator = nil
    }

    private func clear() {
        operand1 = 0
        operand2 = 0
        currentOperator = nil
        text = "0"
    }

    private func handleDecimalInput() {
        if !text.contains(".") {
            text.append(".")
        }
    }

    private func handlePercentInput() {
        currentDisplayValue *= 0.01
    }

    private func toggleNegative() {
        currentDisplayValue = -currentDisplayValue
    }
}
