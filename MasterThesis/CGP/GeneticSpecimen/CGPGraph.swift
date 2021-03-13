//
//  CGPGraph.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

import Foundation

class CGPGraph: GeneticSpecimen {

    struct Size {

        let rows: Int
        let columns: Int

        var items: Int {
            rows * columns
        }
    }

    var fitness = -Double.infinity

    private let levelsBack: Int
    private let inputs: Int
    private let outputs: Int
    private let dimension: Size

    private let operationSet: CGPOperationSet

    private let nodes: [CGPNode]
    private var nodeInputs: [Int: [Int]]

    private var activeNodes = Set<Int>()

    var graphDescription: String {

        var description = ""

        description.append("\(inputs) ")
        description.append("\(outputs) ")
        description.append("\(levelsBack) ")

        description.append("\(dimension.rows) ")
        description.append("\(dimension.columns) ")

        for nodeIndex in (inputs ..< inputs + dimension.items) {

            let node = nodes[nodeIndex]

            let nodeConnections = nodeInputs[nodeIndex]!.map(String.init)

            description.append("\(operationSet.index(of: node.operation)) \(nodeConnections.joined(separator: " ")) ")
        }

        for nodeIndex in (nodes.count - outputs ... nodes.count - 1) {

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
    init(dna: [Int], operationSet: CGPOperationSet) {

        self.operationSet = operationSet

        var dna = dna

        inputs = dna.removeFirst()
        outputs = dna.removeFirst()
        levelsBack = dna.removeFirst()

        dimension = .init(rows: dna.removeFirst(), columns: dna.removeFirst())

        let operationNodesDNAs = dna.prefix(dimension.items * 3)

        dna.removeFirst(dimension.items * 3)

        var nodes: [CGPNode] = ( 0 ..< inputs).map { _ in PassthroughNode() }

        var nodeInputs = [Int: [Int]]()
        var index = 0

        while true {

            guard index < (operationNodesDNAs.count + 1) / 3 else {
                break
            }

            nodes.append(OperationNode(operation: operationSet.at(index: operationNodesDNAs[index])))

            nodeInputs[index + inputs] = [operationNodesDNAs[3 * index + 1],
                                          operationNodesDNAs[3 * index + 2]]

            index += 1
        }

        index = inputs + dimension.items

        // We removed all the other stuff
        let outputNodesDna = dna

        for (outputIndex, outputNodeDna) in outputNodesDna.enumerated() {

            nodeInputs[index + outputIndex] = [outputNodeDna]

            nodes.append(PassthroughNode())
        }

        self.nodeInputs = nodeInputs

        self.nodes = nodes

        recalculateActiveNodes()
    }

    init(inputs: Int, outputs: Int,
         levelsBack: Int, dimension: CGPGraph.Size,
         operationSet: CGPOperationSet) {

        self.inputs = inputs
        self.outputs = outputs

        self.levelsBack = levelsBack

        self.dimension = dimension

        self.operationSet = operationSet

        let inputNodes: [CGPNode] = (0 ..< inputs).map { _ in PassthroughNode() }

        let operationNodes: [CGPNode] = (0 ..< (dimension.columns * dimension.rows)).map { _ in
            OperationNode(operation: operationSet.random)
        }

        let outputNodes: [CGPNode] = (0 ..< outputs).map { _ in PassthroughNode() }

        nodes = [inputNodes, operationNodes, outputNodes].flatMap { $0 }

        nodeInputs = [:]

        compile()
    }

    private func recalculateActiveNodes() {

        activeNodes.removeAll(keepingCapacity: true)

        // We know nodes connected to outputs are active so that's a
        // starting point
        nodeInputs
            .sorted {
                $0.key < $1.key
            }
            .suffix(outputs)
            .forEach { key, value in

                guard let first = value.first, value.count == 1 else {
                    fatalError("Output connected to multiple nodes")
                }

                self.activeNodes.insert(key)
                self.activeNodes.insert(first)
            }

        while true {

            var didMakeAnInsertion = false

            for activeNode in activeNodes {

                guard let activeNodeInputs = nodeInputs[activeNode] else {
                    continue
                }

                for activeNodeInput in activeNodeInputs {

                    let (didInsert, _) = activeNodes.insert(activeNodeInput)

                    didMakeAnInsertion = didInsert || didMakeAnInsertion
                }
            }

            guard didMakeAnInsertion else {
                break
            }
        }
    }

    private func maxConnectedNodeIndexForOperationNode(_ node: Int) -> Int {

        let nodeColumn = Int(floor(Double(node - inputs) / Double(dimension.rows)))

        return (inputs + (nodeColumn) * dimension.rows) - 1
    }

    private func minConnectedNodeIndexForOperationNode(_ node: Int, maxConnectedNodeIndex: Int) -> Int {
        max(0, maxConnectedNodeIndex - levelsBack * dimension.rows)
    }

    private func operationNodeConnectionRange(for node: Int) -> ClosedRange<Int> {

        let max = maxConnectedNodeIndexForOperationNode(node)

        return (minConnectedNodeIndexForOperationNode(node, maxConnectedNodeIndex: max) ... max)
    }

    private func outputNodeConnectionRange() -> ClosedRange<Int> {

        let firstOperationNodeIndex = inputs
        let lastOperationNodeIndex = firstOperationNodeIndex + dimension.items

        let lastColumnFirstOperationNodeIndex = lastOperationNodeIndex - dimension.rows

        return (lastColumnFirstOperationNodeIndex ... lastOperationNodeIndex)
    }

    private enum NodeType {

        case operation
        case input
        case output
    }

    private func nodeType(forNodeAtIndex index: Int) -> NodeType {

        guard index <= nodes.count else {
            fatalError("Impossible index requested")
        }

        switch index {
        case -.max ..< 0:
            fatalError()
        case 0 ..< inputs:
            return .input
        case inputs ..< inputs + dimension.items:
            return .operation
        case inputs + dimension.items ..< inputs + dimension.items + outputs:
            return .output
        default:
            fatalError("Index unrecognized")
        }
    }

    private func connectNodes() {

        let firstOperationNodeIndex = inputs
        let lastOperationNodeIndex = firstOperationNodeIndex + dimension.items - 1

        for nodeIndex in (firstOperationNodeIndex ... lastOperationNodeIndex) {

            let nodeColumn = Int(floor(Double(nodeIndex - inputs) / Double(dimension.rows)))

            let maxConnectedNodeIndex = (inputs + (nodeColumn) * dimension.rows) - 1

            let minConnectedNodeIndex = max(0, maxConnectedNodeIndex - levelsBack * dimension.rows)

            var connections = [Int]()

            while connections.count < operationSet.numberOfInputs {

                connections.append((minConnectedNodeIndex ... maxConnectedNodeIndex).randomElement()!)
            }

            nodeInputs[nodeIndex] = connections
        }

        let lastColumnFirstOperationNodeIndex = lastOperationNodeIndex - dimension.rows + 1

        for outputNodeIndex in (lastOperationNodeIndex + 1 ..< nodes.count) {

            let randomOutputInput = (lastColumnFirstOperationNodeIndex ... lastOperationNodeIndex).randomElement()!

            nodeInputs[outputNodeIndex] = [randomOutputInput]
        }

        recalculateActiveNodes()
    }

    private func mutateRandomOperation() {

        let maxOperationNodeIndex = inputs + dimension.columns * dimension.columns

        let randomActiveOperationNode = activeNodes
            .filter { (inputs ..< maxOperationNodeIndex).contains($0) }
            .randomElement()!

        nodes[randomActiveOperationNode].operation = operationSet.random
    }

    private func mutateRandomConnection() {

        let randomActiveNode = activeNodes
            .filter { $0 >= inputs }
            .randomElement()!

        switch nodeType(forNodeAtIndex: randomActiveNode) {
        case .input:
            fatalError("Input could not be chosen")
        case .operation:

            var connections = nodeInputs[randomActiveNode]!

            let randomIndexToMutate = connections.indices.randomElement()!

            connections[randomIndexToMutate] = operationNodeConnectionRange(for: randomActiveNode)
                                               .randomElement()!

            nodeInputs[randomActiveNode] = connections
        case .output:

            nodeInputs[randomActiveNode] = [outputNodeConnectionRange().randomElement()!]
        }

        recalculateActiveNodes()
    }

    // MARK: - Public

    /// Performs initial node connecting
    func compile() {
        connectNodes()
    }

    private enum MutationType: CaseIterable {

        case operation
        case input

        static var random: MutationType {
            allCases.randomElement()!
        }
    }

    func mutate() {

        switch MutationType.random {
        case .input:
            mutateRandomConnection()
        case .operation:
            mutateRandomOperation()
        }
    }

    func mutated() -> CGPGraph {

        let copy = CGPGraph(dna: dna, operationSet: operationSet)

        copy.mutate()

        copy.fitness = -.infinity

        return copy
    }

    func prediction(for inputs: [Double]) -> [Double] {

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

    // Mark: - Public Static

    static func combine(left: CGPGraph, right: CGPGraph) -> CGPGraph {

        let randomPoint = (5 ... left.dna.count).randomElement()!

        let leftDna = left.dna.prefix(randomPoint)
        let rightDna = right.dna.suffix(right.dna.count - randomPoint)

        let newDna = leftDna + rightDna

        return .init(dna: Array(newDna), operationSet: left.operationSet)
    }
}
