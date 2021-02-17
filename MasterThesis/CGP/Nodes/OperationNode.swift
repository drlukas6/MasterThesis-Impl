//
//  OperationNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class OperationNode: CGPNode {

    var inputs: [CGPNode] = []
    private var operation: Operation

    private(set) var output: Double = 0

    var description: String {
        operation.description + "(" + inputs.map { $0.description }.joined(separator: ", ") + ")"
    }

    init(operation: Operation) {

        self.operation = operation
    }

    func calculateOutput() {
        output = operation.execute(with: inputs.map { input in input.output })
    }
}
