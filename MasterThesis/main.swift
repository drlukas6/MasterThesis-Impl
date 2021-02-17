//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation

let graph = CGPGraph(levelsBack: 1, inputs: 3, outputs: 3, dimension: .init(rows: 4, columns: 10))
graph.compile()

print(graph.description)

print("-----")

print("OUTPUT for [2.3, 5.3, 2.4] = \(graph.process(inputs: [1, 2, 3]))")
