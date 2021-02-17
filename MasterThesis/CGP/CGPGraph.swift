//
//  CGPGraph.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class CGPGraph {

    struct Size {
        let rows: Int
        let columns: Int
    }

    var fitness = Double.infinity

    private let levelsBack: Int
    private let inputs: Int
    private let outputs: Int
    private let dimension: Size
    private let nodes: [[CGPNode]]

    var inputNodes: [PassthroughNode] {
        nodes.first! as! [PassthroughNode]
    }

    var outputNodes: [OutputNode] {
        nodes.last! as! [OutputNode]
    }

    init(levelsBack: Int, inputs: Int, outputs: Int, dimension: CGPGraph.Size) {

        self.levelsBack = levelsBack
        self.inputs = inputs
        self.outputs = outputs
        self.dimension = dimension

        nodes = (0 ..< 1 + dimension.columns + 1).map { index in

            switch index {
            case 0:
                return (0 ..< inputs).map { _ in
                    PassthroughNode()
                }
            case 1...dimension.columns:
                return (0 ..< dimension.rows).map { _ in
                    OperationNode(operation: Operation.random)
                }
            case dimension.columns + 1:
                return (0 ..< outputs).map { _ in
                    OutputNode()
                }
            default:
                fatalError("Unexpected index")
            }
        }
    }

    /// Performs initial node connecting
    func compile() {
        connectNodes()
    }

    private func connectNodes() {

        for column in (1 ... dimension.columns) {

            for row in (0 ..< dimension.rows) {

                // TODO: Check for same node multiple input

                guard let operationNode = nodes[column][row] as? OperationNode else {
                    fatalError("Unexpected node type")
                }

                operationNode.inputs.removeAll()

                for _ in [0, 1] {

                    let colIndex = max(0, column - levelsBack)

                    operationNode.inputs.append(nodes[colIndex].randomElement()!)
                }
            }
        }

        for outputNode in outputNodes {
            outputNode.input = nodes[dimension.columns].randomElement()!
        }
    }

    func mutate() {
        fatalError("Implement me")
    }

    func process(inputs: [Double]) -> [Double] {

        guard inputs.count == self.inputs else {
            fatalError("Number of inputs does not match networks specification. \(inputs.count) != \(self.inputs)")
        }

        for (input, inputNode) in zip(inputs, inputNodes) {
            inputNode.input = input
            inputNode.calculateOutput()
        }

        for nodeColumn in nodes.suffix(from: 1) {
            for node in nodeColumn {
                node.calculateOutput()
            }
        }

        return outputNodes.map { node in node.output }
    }
}

extension CGPGraph: CustomStringConvertible {

    var description: String {

        var description = ""

        description += "==== INPUT NODES \(inputs)====\n"

        description += inputNodes.map { $0.description }.joined(separator: "\n")

        description += "\n"

        description += "==== OPERATION NODES \(dimension.columns) x \(dimension.rows) ====\n"

        for column in (1 ... dimension.columns) {
            description += "COLUMN\(column - 1)\n"
            description += nodes[column].map { $0.description }.joined(separator: "\n")
            description += "\n"
        }

        description += "==== OUTPUT NODES \(outputs)====\n"
        description += outputNodes.map { $0.description }.joined(separator: "\n")

        return description
    }
}
