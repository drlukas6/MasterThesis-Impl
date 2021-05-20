//
//  EdgeDetectionOperationSet.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.04.2021..
//

import Darwin

private extension Double {

    static let epsilon = 1e-3
}

struct EdgeDetectionOperationSet: CGPOperationSet {

    var operations: [CGPOperation] {
        EdgeDetectionOperation.allCases
    }

    let numberOfInputs: Int

    init(numberOfInputs: Int = 9) {

        self.numberOfInputs = numberOfInputs
    }
}

enum EdgeDetectionOperation: CaseIterable, CGPOperation {

    case add
    case subtract
    case multiply
    case divide
    case sqrt
    case avg
    case min
    case max
    case ln
    case sin
    case cos
    case step

    var inputs: Int {

        switch self {
        case .add, .subtract, .multiply, .divide:
            return 2
        case .sqrt, .sin, .ln, .cos, .step:
            return 1
        case .avg, .min, .max:
            return .max
        }
    }

    func execute(with input: [Double]) -> Double {

        switch self {
        case .add:          return input[0] + input[1]
        case .subtract:     return input[0] - input[1]
        case .multiply:     return input[0] * input[1]
        case .divide:       return input[1] <= Double.epsilon ? input[0] : input[0] / input[1]
        case .sqrt:         return Darwin.sqrt(input[0])
        case .avg:          return input.reduce(0, +) / Double(input.count)
        case .min:          return input.min()!
        case .max:          return input.max()!
        case .ln:           return log(input[0])
        case .sin:          return Darwin.sin(input[0])
        case .cos:          return Darwin.cos(input[0])
        case .step:         return input[0] < 0 ? 0 : 1
        }
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? EdgeDetectionOperation else {
            return false
        }

        return self == rhs
    }
}

