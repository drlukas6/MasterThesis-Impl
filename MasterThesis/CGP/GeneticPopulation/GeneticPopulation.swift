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

        var outputs = [Double]()
        outputs.reserveCapacity(datasource.size)

        for row in (0 ..< datasource.size) {

            inputs.append(datasource.input(at: row))
            outputs.append(datasource.output(at: row).first!)
        }

//        process(datasource: datasource, inPopulation: population)
        var (parent, fitness) = process(inputs: inputs, outputs: outputs, inPopulation: population)
        var lastStepChange = 0

//        logger.info("Calculated fitnesses: \(self.population.map(\.fitness))")

//        var parent = population.sorted { (lhs, rhs) -> Bool in
//            lhs.fitness < rhs.fitness
//        }.last!

        logger.info("Best fitness: \(parent.fitness)")

        for step in (0 ..< generations) {

            self.population = [parent] + (0 ..< 4).map { _ in
                parent.mutated()
            }

//            let (topMember, topFitness) = process(datasource: datasource, inPopulation: population)
            let (topMember, topFitness) = process(inputs: inputs, outputs: outputs, inPopulation: population)

            if step % 10 == 0 {
                logger.info("Top fitness in step \(step + 1): \(topFitness)")
            }

            guard step - lastStepChange < 151 else {
                break
            }

            guard topFitness >= parent.fitness && topMember != parent else {
                continue
            }

            lastStepChange = step

            parent = topMember
        }

        logger.info("Finished with top fitness \(parent.fitness)")

        return parent
    }

    // MARK: - Private

    /// Performs a step with a given datasource
    /// - Returns: Best CGP Graph and its fitness
    @discardableResult
    private func process(inputs: [[Double]], outputs: [Double], inPopulation population: [CGPGraph]) -> (CGPGraph, Double) {

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
}
