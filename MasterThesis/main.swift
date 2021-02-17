//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation

let graph = CGPGraph(levelsBack: 3, inputs: 3, outputs: 3, dimension: .init(rows: 2, columns: 10))
graph.compile()

print(graph.description)
