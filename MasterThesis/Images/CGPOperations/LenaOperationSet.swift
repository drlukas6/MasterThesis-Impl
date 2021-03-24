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

    func execute(with input: [Double]) -> Double {

        switch self {
        case .max: return input.max()!
        case .min: return input.min()!
        case .average: return input.reduce(0, +) / Double(input.count)
        case .mean: return input.sorted()[input.count / 2]
        case .modSum: return input.reduce(0, +).truncatingRemainder(dividingBy: 256)
        case .sqrtSum: return input.reduce(0, +).squareRoot()
        }
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? LenaOperation else {
            return false
        }

        return self == rhs
    }
}
