//
//  Operation.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Darwin

enum Operation: CaseIterable {

    case add
    case substract
    case multiply
    case divide
    case sin
    case cos

    func execute(with input: [Double]) -> Double {

        switch self {
        case .add: return input[0] + input[1]
        case .substract: return input[0] - input[1]
        case .multiply: return input[0] * input[1]
        case .divide: return input[0] / input[1]
        case .sin: return Darwin.sin(input[0])
        case .cos: return Darwin.cos(input[0])
        }
    }

    var description: String {

        switch self {
        case .add: return "+"
        case .substract: return "-"
        case .multiply: return "x"
        case .divide: return "/"
        case .sin: return "sin"
        case .cos: return "cos"
        }
    }

    static var random: Operation {
        allCases.randomElement()!
    }
}
