//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation

let graph = CGPGraph(inputs: 3, outputs: 1, levelsBack: 1, dimension: .init(rows: 2, columns: 5))
graph.compile()

print(graph.dna)

print("-----")

print("OUTPUT for [1, 2, 3] = \(graph.prediction(for: [1, 2, 3]))")
