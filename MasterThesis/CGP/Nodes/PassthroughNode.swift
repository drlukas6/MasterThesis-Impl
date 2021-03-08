//
//  PassthroughNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class PassthroughNode: CGPNode {

    var inputs: [Double] = []

    private(set) var output: Double = 0

    let description = "P\(UUID().uuidString.prefix(5))"

    func calculateOutput() {
        output = inputs.first!
    }
}
