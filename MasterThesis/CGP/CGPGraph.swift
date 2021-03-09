//
//  CGPGraph.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

// 0 0 2
// operation input1 input2

// izlazi su samo npr. 0 tj index operacije

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

    private let nodes: [CGPNode]
    private var nodeInputs: [Int: [Int]]

    var graphDescription: String {

        var description = ""

        description.append("\(inputs) ")
        description.append("\(outputs) ")
        description.append("\(levelsBack) ")

        description.append("\(dimension.rows) ")
        description.append("\(dimension.columns) ")

        for nodeIndex in (inputs ... inputs + dimension.rows * dimension.columns) {

            let node = nodes[nodeIndex]

            let nodeConnections = nodeInputs[nodeIndex]!.map(String.init)

            description.append("\(Operation.index(of: node.operation)) \(nodeConnections.joined(separator: " ")) ")
        }

        for nodeIndex in (nodes.count - outputs - 1 ..< nodes.count - 1) {

            description.append("\(nodeInputs[nodeIndex]!.first!) ")
        }

        return description
    }

    var dna: [Int] {
        graphDescription
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .compactMap { str in Int(str) }
    }

    /// DNA format: nInputs nOutputs nLevelsBack nRows nColumns (nRows x nColumns) * (nOperation indexInput1 indexInput2) (nOutpus) * indexInput
    init(dna: String) {

        var dna = dna.split(separator: " ").compactMap { Int($0) }

        inputs = dna.removeFirst()
        outputs = dna.removeFirst()
        levelsBack = dna.removeFirst()

        dimension = .init(rows: dna.removeFirst(), columns: dna.removeFirst())

        let operationNodesDNAs = dna.dropFirst(dimension.rows * dimension.columns)

        var nodes: [CGPNode] = ( 0 ..< inputs).map { _ in PassthroughNode() }

        var nodeInputs = [Int: [Int]]()
        var index = inputs
        while true {

            guard index < operationNodesDNAs.count + inputs else {
                break
            }

            nodes.append(OperationNode(operation: .at(index: operationNodesDNAs[index])))
            nodeInputs[index] = [operationNodesDNAs[index + 1],
                                 operationNodesDNAs[index + 2]]

            index += 3
        }

        index += 1

        // We removed all the other stuff
        let outputNodesDna = dna

        for (outputIndex, outputNodeDna) in outputNodesDna.enumerated() {

            nodeInputs[index + outputIndex] = [outputNodeDna]

            nodes.append(PassthroughNode())
        }

        self.nodeInputs = nodeInputs

        self.nodes = nodes
    }

    init(inputs: Int, outputs: Int, levelsBack: Int, dimension: CGPGraph.Size) {

        self.inputs = inputs
        self.outputs = outputs

        self.levelsBack = levelsBack

        self.dimension = dimension

        let inputNodes: [CGPNode] = (0 ..< inputs).map { _ in PassthroughNode() }

        let operationNodes: [CGPNode] = (0 ..< (dimension.columns * dimension.rows)).map { _ in
            OperationNode(operation: .random)
        }

        let outputNodes: [CGPNode] = (0 ..< outputs).map { _ in PassthroughNode() }

        nodes = [inputNodes, operationNodes, outputNodes].flatMap { $0 }

        nodeInputs = [:]
    }

    /// Performs initial node connecting
    func compile() {
        connectNodes()
    }

    private func connectNodes() {

        let firstOperationNodeIndex = inputs
        let lastOperationNodeIndex = firstOperationNodeIndex + dimension.rows * dimension.columns

        // 3 ulaza
        // 5 stupca
        // 2 retka
        // 1 izlaz

        // 9
        for nodeIndex in (firstOperationNodeIndex ... lastOperationNodeIndex) {

            // in in in | op op | op op | op op | op op | op op | iz
            //                                    ^ // < 4. stupac

            //  9 - 3 = 6 // bez ulaza
            // stupac je ceil(6 / brojredaka)

            // step 1. find max connectable node index

            // vraca 3 (broji se od 0)
            let nodeColumn = Int(floor(Double(nodeIndex - inputs) / Double(dimension.rows)))

            let maxConnectedNodeIndex = (inputs + (nodeColumn) * dimension.rows) - 1

            let minConnectedNodeIndex = max(0, maxConnectedNodeIndex - levelsBack * dimension.rows)

            var connections = Set<Int>()

            while connections.count < 2 {

                connections.insert((minConnectedNodeIndex ... maxConnectedNodeIndex).randomElement()!)
            }

            nodeInputs[nodeIndex] = Array(connections)
        }

        let lastColumnFirstOperationNodeIndex = lastOperationNodeIndex - dimension.rows

        for outputNodeIndex in (lastOperationNodeIndex + 1 ... nodes.count) {

            nodeInputs[outputNodeIndex] = [(lastColumnFirstOperationNodeIndex ... lastOperationNodeIndex).randomElement()!]
        }
    }

    func mutate() {
        fatalError("Implement me")
    }

    func process(inputs: [Double]) -> [Double] {

        guard inputs.count == self.inputs else {
            fatalError("Number of inputs does not match networks specification. \(inputs.count) != \(self.inputs)")
        }

        for (index, input) in inputs.enumerated() {
            nodes[index].inputs = [input]
        }

        for (index, node) in nodes.suffix(nodes.count - self.inputs).enumerated() {

            node.inputs = nodeInputs[index + self.inputs]!.map { nodeIndex in
                self.nodes[nodeIndex].output
            }

            node.calculateOutput()
        }

        return nodes.suffix(outputs).map { node in node.output }
    }
}
