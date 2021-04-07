//
//  LenaOperationSet.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Darwin

struct LenaOperationSet: CGPOperationSet {

    var operations: [CGPOperation] {
        LenaOperation.allCases
    }

    let numberOfInputs: Int

    init(numberOfInputs: Int) {
        self.numberOfInputs = numberOfInputs
    }
}

enum LenaOperation: CaseIterable, CGPOperation {

    case max
    case min
    case average
    case mean
    case modSum
    case sqrtSum
    case maxMinDiff
    case none
    case white
    case sin
    case cos
    case rsqrt
    case exp
    case sqrtDivided

    func execute(with input: [Double]) -> Double {

        switch self {
        case .max: return input.max()!
        case .min: return input.min()!
        case .average: return input.reduce(0, +) / Double(input.count)
        case .mean: return input.sorted()[input.count / 2]
        case .modSum: return input.reduce(0, +).truncatingRemainder(dividingBy: 256)
        case .sqrtSum: return input.reduce(0, +).squareRoot()
        case .maxMinDiff: return input.max()! - input.min()!
        case .none: return 0
        case .white: return 255
        case .sin: return Darwin.sin(input.first!) * 255
        case .cos: return Darwin.cos(input.first!) * 255
        case .rsqrt: return 1 / sqrt(input.first!)
        case .exp: return Darwin.exp(input[0] + input[1]).truncatingRemainder(dividingBy: 256)
        case .sqrtDivided: return sqrt((pow(input[0], 2) + pow(input[1], 2)) / 2)
        }
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? LenaOperation else {
            return false
        }

        return self == rhs
    }
}
