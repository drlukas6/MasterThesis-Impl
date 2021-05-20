//
//  ImageProcessingCGPOperationSet.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 20.04.2021..
//

import Darwin

private extension Double {

    static let epsilon = 1e-3
}

struct ImageProcessingCGPEdgeDetectionOperationSet: CGPOperationSet {

    var operations: [CGPOperation] {
        ImageProcessingCGPEdgeDetectionOperation.allCases
    }

    let numberOfInputs: Int

    init(numberOfInputs: Int = 9) {

        self.numberOfInputs = numberOfInputs
    }

}

enum ImageProcessingCGPEdgeDetectionOperation: CaseIterable, CGPOperation {

    case add
    case sub
    case mult
    case div
    case sqrt
    case pow
    case square
    case cos
    case sin
    case nop
    case absolute
    case min
    case max
    case ceil
    case floor
    case frac
    case log2
    case recip
    case rsqrt
    case avg

    var inputs: Int {

        switch self {

        case .add:      return 2
        case .sub:      return 2
        case .mult:     return 2
        case .div:      return 2
        case .sqrt:     return 1
        case .pow:      return 2
        case .square:   return 1
        case .cos:      return 1
        case .sin:      return 1
        case .nop:      return 1
        case .absolute: return 1
        case .min:      return 9
        case .max:      return 9
        case .ceil:     return 1
        case .floor:    return 1
        case .frac:     return 1
        case .log2:     return 1
        case .recip:    return 1
        case .rsqrt:    return 1
        case .avg:      return 8
        }
    }

    func execute(with input: [Double]) -> Double {

        switch self {

        case .add:      return input[0] + input[1]
        case .sub:      return input[1] - input[0]
        case .mult:     return input[0] * input[1]
        case .div:      return abs(input[1]) < Double.epsilon ? input[0] : input[0] / input[1]
        case .sqrt:     return Darwin.sqrt(input[0])
        case .pow:      return Darwin.pow(input[0], input[1])
        case .square:   return Darwin.pow(input[0], 2)
        case .cos:      return Darwin.cos(input[0])
        case .sin:      return Darwin.sin(input[0])
        case .nop:      return input[0]
        case .absolute: return abs(input[0])
        case .min:      return input.min()!
        case .max:      return input.max()!
        case .ceil:     return Darwin.ceil(input[0])
        case .floor:    return Darwin.floor(input[0])
        case .frac:     return input[0] - Darwin.floor(input[0])
        case .log2:     return Darwin.log2(input[0])
        case .recip:    return 1 / input[0]
        case .rsqrt:    return 1 / Darwin.sqrt(input[0])
        case .avg:      return Double(input.reduce(0, +)) / Double(input.count)
        }
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? ImageProcessingCGPEdgeDetectionOperation else {
            return false
        }

        return self == rhs
    }
}

