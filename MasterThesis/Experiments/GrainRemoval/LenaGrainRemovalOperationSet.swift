//
//  LenaGrainRemovalOperationSet.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.04.2021..
//

import Darwin

struct LenaGrainRemovalOperationSet: CGPOperationSet {

    var operations: [CGPOperation] {
        LenaOperation.allCases
    }

    let numberOfInputs: Int

    init(numberOfInputs: Int) {
        self.numberOfInputs = numberOfInputs
    }
}

enum LenaGrainRemovalOperation: CaseIterable, CGPOperation {

    case max
    case min
    case average
    case mean
    case modSum
    case sqrtSum
    case maxMinDiff
    case none

    var inputs: Int {

        switch self {
        case .none:
            return 1
        case .max, .min, .average, .mean, .modSum, .sqrtSum, .maxMinDiff:
            return .max
        }
    }

    func execute(with input: [Double]) -> Double {

        switch self {
        case .max:          return input.max()!
        case .min:          return input.min()!
        case .average:      return input.reduce(0, +) / Double(input.count)
        case .mean:         return input.sorted()[input.count / 2]
        case .modSum:       return input.reduce(0, +).truncatingRemainder(dividingBy: 256)
        case .sqrtSum:      return input.reduce(0, +).squareRoot()
        case .maxMinDiff:   return input.max()! - input.min()!
        case .none: return 0
        }
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? LenaGrainRemovalOperation else {
            return false
        }

        return self == rhs
    }
}

