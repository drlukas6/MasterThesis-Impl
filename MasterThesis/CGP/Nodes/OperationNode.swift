//
//  OperationNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class OperationNode: CGPNode {

    var inputs: [Double]

    private var operation: DefaultCGPOperation

    private(set) var output: Double = 0

    var description: String {
        operation.description + "(" + inputs.map { $0.description }.joined(separator: ", ") + ")"
    }

    init(operation: DefaultCGPOperation) {

        self.operation = operation
    }

    func calculateOutput() {
        output = operation.execute(with: inputs)
    }
}
