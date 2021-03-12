//
//  OperationNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class OperationNode: CGPNode {

    var inputs: [Double] = []

    var operation: CGPOperation

    private(set) var output: Double = 0

    init(operation: CGPOperation) {

        self.operation = operation
    }

    func calculateOutput() {
        output = operation.execute(with: inputs)
    }
}
