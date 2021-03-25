//
//  GeneticPopulation.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation
import os.log

class CGPPopulation {

    struct GraphParameters {

        let inputs: Int
        let outputs: Int
        let levelsBack: Int
        let dimension: CGPGraph.Size
        let operationsSet: CGPOperationSet

        func makeGraph() -> CGPGraph {

            .init(inputs: inputs, outputs: outputs,
                  levelsBack: levelsBack,
                  dimension: dimension,
                  operationSet: operationsSet)
        }
    }

    private let logger = Logger()

    var population: [CGPGraph]

    private let fitnessCalculator: FitnessCalculator
    private let graphParameters: GraphParameters

    init(fitnessCalculator: FitnessCalculator, graphParameters: GraphParameters) {

        self.fitnessCalculator = fitnessCalculator
        self.graphParameters = graphParameters

        population = (0 ..< 4).compactMap { _ in graphParameters.makeGraph() }
    }

    /// Processes a whole dataset for the given number of generations and returns the
    /// best performing CGPGraph
    func process(withDatasource datasource: Datasource, forGenerations generations: Int) -> CGPGraph {

        var inputs = [[Double]]()
        inputs.reserveCapacity(datasource.size)

        var outputs = [[Double]]()
        outputs.reserveCapacity(datasource.size)

        for row in (0 ..< datasource.size) {

            inputs.append(datasource.input(at: row))
            outputs.append(datasource.output(at: row))
        }

        process(datasource: datasource, inPopulation: population)

//        logger.info("Calculated fitnesses: \(self.population.map(\.fitness))")

        var parent = population.sorted { (lhs, rhs) -> Bool in
            lhs.fitness < rhs.fitness
        }.last!

        logger.info("Best fitness: \(parent.fitness)")

        for step in (0 ..< generations) {

            logger.debug("Doing step: \(step)")

            self.population = [parent] + (0 ..< 4).map { _ in
                parent.mutated()
            }

            let (topMember, topFitness) = process(datasource: datasource, inPopulation: population)

            logger.info("Top fitness in step \(step + 1): \(topFitness)")

            if topFitness >= parent.fitness {

                parent = topMember
            }
        }

        logger.info("Finished with top fitness \(parent.fitness)")

        return parent
    }

    // MARK: - Private

    /// Performs a step with a given datasource
    /// - Returns: Best CGP Graph and its fitness
    @discardableResult
    private func process2(inputs: [[Double]], outputs: [Double], inPopulation population: [CGPGraph]) -> (CGPGraph, Double) {

        var histories: [[Double]] = (0 ..< population.count).map { _ in [] }

        for input in inputs {

            for (index, member) in population.enumerated() {

                let prediction = member.prediction(for: input).first!

                histories[index].append(prediction)
            }
        }

        let qualities = histories.enumerated().map { index, history -> Double in

            let (fitness, _) = fitnessCalculator.calculateFitness(fromPredictions: history, groundTruth: outputs)

            population[index].fitness = fitness

            return fitness
        }

        let bestFitness = qualities.max()!
        let best = population[qualities.firstIndex(of: bestFitness)!]

        return (best, bestFitness)
    }

    /// Performs a step with a given datasource
    /// - Returns: Best CGP Graph and its fitness
    @discardableResult
    private func process(datasource: Datasource, inPopulation population: [CGPGraph]) -> (CGPGraph, Double) {

        var topMember = population.first!
        var topFitness = -Double.infinity

        let truth = (0 ..< datasource.size).map { row in datasource.output(at: row).first! }

        for member in population {

            let memberPredictions = (0 ..< datasource.size).map { row -> Double in

                let input  = datasource.input(at: row)

                let memberPrediction = member.prediction(for: input).first!

                return memberPrediction
            }

            let (calculatedFitness, mse) = fitnessCalculator.calculateFitness(fromPredictions: memberPredictions,
                                                                              groundTruth: truth)

//            logger.info("Calculated fitness: \(calculatedFitness), error: \(mse)")

            member.fitness = calculatedFitness

            if calculatedFitness >= topFitness {
                topMember = member
                topFitness = calculatedFitness
            }
        }

        return (topMember, topFitness)
    }
}
