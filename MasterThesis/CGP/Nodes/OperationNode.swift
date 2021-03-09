//
//  OperationNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class OperationNode: CGPNode {

    var inputs: [Double] = []

    private(set) var operation: Operation

    private(set) var output: Double = 0

    init(operation: Operation) {

        self.operation = operation
    }

    func calculateOutput() {
        output = operation.execute(with: inputs)
    }
}
