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

    let numberOfInputs = 2
}

enum DefaultOperation: CaseIterable, CGPOperation {

    case add
    case substract
    case multiply
    case divide
    case sin
    case cos

    var inputs: Int {

        switch self {
        case .add, .substract, .multiply, .divide:
            return 2
        case .sin, .cos:
            return 1
        }
    }

    func execute(with input: [Double]) -> Double {

        switch self {
        case .add: return input[0] + input[1]
        case .substract: return input[0] - input[1]
        case .multiply: return input[0] * input[1]
        case .divide: return abs(input[1]) < .epsilon ? input[0] : input[0] / input[1]  // !< if denominator is 0, works as identity
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
}

