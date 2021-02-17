//
//  OutputNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class OutputNode: CGPNode {

    var input: CGPNode!
    private(set) var output: Double = 0

    let description = "O\(UUID().uuidString.prefix(5))"

    func calculateOutput() {
        output = input.output
    }
}
