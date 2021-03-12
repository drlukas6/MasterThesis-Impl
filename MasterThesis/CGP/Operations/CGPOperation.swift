//
//  CGPOperation.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

protocol CGPOperation {

    func execute(with input: [Double]) -> Double
    func isEqual(to rhs: CGPOperation) -> Bool
}

struct IdentityOperation: CGPOperation {

    func execute(with input: [Double]) -> Double {
        1
    }

    func isEqual(to rhs: CGPOperation) -> Bool {
        false
    }
}

protocol CGPOperationSet {

    var operations: [CGPOperation] { get }
}

extension CGPOperationSet {

    var random: CGPOperation {
        operations.randomElement()!
    }

    func at(index: Int) -> CGPOperation {
        operations[index]
    }

    func index(of operation: CGPOperation) -> Int {
        operations.firstIndex(where: { $0.isEqual(to: operation) } )!
    }
}
