//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation

let experiment = TestSymbolicRegressionExperiment()

let best = experiment.startExperiment()

print("Best fitness: \(best.fitness)")
