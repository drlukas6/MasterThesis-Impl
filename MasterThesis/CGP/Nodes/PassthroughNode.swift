//
//  PassthroughNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class PassthroughNode: CGPNode {

    var operation: Operation = .add

    var inputs: [Double] = [] {
        didSet {
            calculateOutput()
        }
    }

    private(set) var output: Double = 0

    func calculateOutput() {
        output = inputs.first!
    }
}
