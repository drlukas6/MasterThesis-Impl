//
//  SingleCGPEvolution.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 28.04.2021..
//

import Foundation
import os.log

struct CGPGraphBuild {

    let inputs: Int
    let outputs: Int

    let levelsBack: Int
    let dimension: CGPGraph.Size

    let operationSet: CGPOperationSet
}

struct CheckpointHandler {

    let checkpointCallStep: Int

    let checkpointHandler: (Int, CGPGraph, CGPGraph) -> Void

    static var empty: Self {
        .init(checkpointCallStep: .max, checkpointHandler: { _, _, _ in })
    }
}

var errCount = [Double]()


/// Trains two CGPGraphs switching between currently evolved graph every `switchStep` steps for `generations` generations
/// - Parameters:
///   - graph1Build: Instructions to build the first CGP
///   - graph2Build: Instructions to build the second CGP
///   - truth: Ground truth values expected of the second CGP output
///   - generations: Number of generations to process
///   - switchStep: How often to switch the currently evolved CGP
/// - Returns: Two CGPGraphs
func evolve(graph1Build: CGPGraphBuild, graph2Build: CGPGraphBuild,
            truth: [[Double]],
            fitnessCalculator: FitnessCalculator,
            generations: Int,
            switchStep: Int,
            checkpointHandler: CheckpointHandler = .empty) -> (CGPGraph, CGPGraph) {

    let logger = Logger()

    let populationSize = 8

    var graph1 = CGPGraph(inputs: graph1Build.inputs, outputs: graph1Build.outputs,
                          levelsBack: graph1Build.levelsBack,
                          dimension: graph1Build.dimension,
                          operationSet: graph1Build.operationSet)

    graph1.shouldFitOutputToUInt8 = false

    var graph2 = CGPGraph(inputs: graph2Build.inputs, outputs: graph2Build.outputs,
                          levelsBack: graph2Build.levelsBack,
                          dimension: graph2Build.dimension,
                          operationSet: graph2Build.operationSet)

    var currentlyTrainedGraph = graph1

    for iteration in (1 ... generations) {

        if currentlyTrainedGraph == graph1 {

            let graph1Population = (0 ..< populationSize).map { _ in graph1.mutated() }
            var bestGraph1 = graph1Population[0]

            let graph1PopulationOutputs = graph1Population.map { graph in
                truth.map { input in
                    graph.prediction(for: input)
                }
            }

            let graph2Outputs = graph1PopulationOutputs.map { graph2Input in
                graph2Input.map { input in
                    graph2.prediction(for: input)
                }
            }

            let errors = graph2Outputs.map { imageOutputs -> Double in

                let error = zip(imageOutputs, truth).map { imageOutput, trueOutput in
                    fitnessCalculator.calculateFitness(fromPredictions: imageOutput, groundTruth: trueOutput)
                }.reduce(0.0) { current, next in
                    current + next.error
                } / Double(truth.count)

                return error
            }

            let minError = errors.min()!

            let bestGraph1Index = errors.firstIndex(of: minError)!

            bestGraph1 = graph1Population[bestGraph1Index]
            bestGraph1.fitness = 1/minError

//            let fitnessErrorPairs = graph2Outputs.map { output in fitnessCalculator.calculateFitness(fromPredictions: output, groundTruth: truth) }
//
//            for (graph1, fitnessErrorPair) in zip(graph1Population, fitnessErrorPairs) {
//
//                graph1.fitness = fitnessErrorPair.fitness
//
//                if fitnessErrorPair.fitness > bestGraph1.fitness {
//                    bestGraph1 = graph1
//                }
//            }
//
            if bestGraph1.fitness >= graph1.fitness {
                graph1 = bestGraph1
            }

//            logger.debug("New best graph1 error: \(1 / graph1.fitness)")
        } else {

            let graph2Population = (0 ..< populationSize).map { _ in graph2.mutated() }
            var bestGraph2 = graph2Population[0]

            let graph1Outputs: [[Double]] = truth.map { datapoint in graph1.prediction(for: datapoint) }

            let graph2PopulationOutputs: [[[Double]]] = graph2Population.map { graph in
                graph1Outputs.map { graph1Output in
                    graph.prediction(for: graph1Output)
                }
            }

            let errors = graph2PopulationOutputs.map { imageOutputs -> Double in

                let error = zip(imageOutputs, truth).map { imageOutput, trueOutput in
                    fitnessCalculator.calculateFitness(fromPredictions: imageOutput, groundTruth: trueOutput)
                }.reduce(0.0) { current, next in
                    current + next.error
                } / Double(truth.count)

                return error
            }

            let minError = errors.min()!

            let bestGraph2Index = errors.firstIndex(of: minError)!

            bestGraph2 = graph2Population[bestGraph2Index]
            bestGraph2.fitness = 1/minError
//
//            let fitnessErrorPairs = graph2PopulationOutputs.map { output in fitnessCalculator.calculateFitness(fromPredictions: output, groundTruth: truth) }
//
//            for (graph2, fitnessErrorPair) in zip(graph2Population, fitnessErrorPairs) {
//
//                graph2.fitness = fitnessErrorPair.fitness
//
//                if fitnessErrorPair.fitness > bestGraph2.fitness {
//                    bestGraph2 = graph2
//                }
//            }
//
            if bestGraph2.fitness >= graph2.fitness {
                graph2 = bestGraph2
            }

//            logger.debug("New best graph2 error: \(1 / graph2.fitness)")
        }

        let trainedGraph = currentlyTrainedGraph == graph1 ? "GRAPH1" : "GRAPH2"
        let errSum = 1 / graph1.fitness + 1 / graph2.fitness
        logger.info("Generation: \(iteration) Active: \(trainedGraph) ERROR1: \(1 / graph1.fitness, align: .left(columns: 7)) ERROR2: \(1 / graph2.fitness, align: .left(columns: 7)) ERRSUM: \(errSum)")

        if iteration % switchStep == 0 {
            currentlyTrainedGraph = currentlyTrainedGraph == graph1 ? graph2 : graph1
        }

        if iteration % checkpointHandler.checkpointCallStep == 0 {
            checkpointHandler.checkpointHandler(iteration, graph1, graph2)
        }
    }

    logger.info("FINAL ERROR: \((1 / graph1.fitness) / pow(255, 2))")
    errCount.append((1 / graph1.fitness) / pow(255, 2))
    return (graph1, graph2)
}
