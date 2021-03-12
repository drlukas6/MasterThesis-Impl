//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation

let graph = CGPGraph(inputs: 3, outputs: 1, levelsBack: 1, dimension: .init(rows: 2, columns: 1))
let graph2 = CGPGraph(inputs: 3, outputs: 1, levelsBack: 1, dimension: .init(rows: 2, columns: 1))

graph.compile()
graph2.compile()

let graph3 = CGPGraph.combine(left: graph, right: graph2)


print("Graph1 for [1, 2, 3] = \(graph.prediction(for: [1, 2, 3]))")
print("Graph2 for [1, 2, 3] = \(graph2.prediction(for: [1, 2, 3]))")
print("Graph3 for [1, 2, 3] = \(graph3.prediction(for: [1, 2, 3]))")
