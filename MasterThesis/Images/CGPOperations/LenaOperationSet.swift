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

        let result: Double

        switch self {
        case .max: result = input.max()!
        case .min: result = input.min()!
        case .average: result = input.reduce(0, +) / Double(input.count)
        case .mean: result = input.sorted()[input.count / 2]
        case .modSum: result = input.reduce(0, +).truncatingRemainder(dividingBy: 256)
        case .sqrtSum: result = input.reduce(0, +).squareRoot()
        case .maxMinDiff: result = input.max()! - input.min()!
        case .none: result = 0
        case .white: result = 255
        case .sin: result = Darwin.sin(input.first!) * 255
        case .cos: result = Darwin.cos(input.first!) * 255
        case .rsqrt: result = 1 / sqrt(input.first!)
        case .exp: result = Darwin.exp(input[0] + input[1]).truncatingRemainder(dividingBy: 256)
        case .sqrtDivided: result = sqrt((pow(input[0], 2) + pow(input[1], 2)) / 2)
        }

        guard result != .nan else {
            fatalError("WHAT")
        }

        let result2 = Double.maximum(Double.minimum(result, 255), 0)

        return result2
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? LenaOperation else {
            return false
        }

        return self == rhs
    }
}
