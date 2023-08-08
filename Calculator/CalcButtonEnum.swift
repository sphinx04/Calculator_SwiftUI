//
//  CalcButtonEnum.swift
//  Calculator
//
//  Created by Sphinx04 on 07.08.23.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "×"
    case equal = "="
    case clear = "C"
    case decimal = ","
    case percent = "%"
    case negative = "-/+"

    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color(red: 1, green: 160/255, blue: 10/255)
        case .clear, .negative, .percent:
            return Color(red: 165/255, green: 165/255, blue: 165/255)
        default:
            return Color(red: 51/255, green: 51/255, blue: 51/255)
        }
    }

    var textColor: Color {
        switch self {
        case .clear, .negative, .percent:
            return .black
        default:
            return .white
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return 50
        default:
            return 40
        }
    }
}
