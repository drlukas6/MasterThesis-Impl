//
//  Operation.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 08.03.2021..
//

import Darwin

private extension Double {

    static let epsilon = 1e-4
}

struct DefaultOperationSet: CGPOperationSet {

    var operations: [CGPOperation] {
        DefaultOperation.allCases
    }
}

enum DefaultOperation: CaseIterable, CGPOperation {

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
        case .divide: return abs(input[1]) < .epsilon ? input[0] : input[0] / input[1]
        case .sin: return Darwin.sin(input[0])
        case .cos: return Darwin.cos(input[0])
        }
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? DefaultOperation else {
            return false
        }

        return self == rhs
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
}

