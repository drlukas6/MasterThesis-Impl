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
    func process(withDatasource datasource: Datasource, forGenerations generations: Int) -> (CGPGraph, History) {

        let history = History()

        var inputs = [[Double]]()
        inputs.reserveCapacity(datasource.size)

        var outputs = [Double]()
        outputs.reserveCapacity(datasource.size)

        for row in (0 ..< datasource.size) {

            inputs.append(datasource.input(at: row))
            outputs.append(datasource.output(at: row).first!)
        }

        var (parent, _) = process(inputs: inputs, outputs: outputs, inPopulation: population)

        logger.info("Best fitness: \(parent.fitness)")

        for step in (0 ..< generations) {

            self.population = [parent] + (0 ..< 4).map { _ in
                parent.mutated()
            }

            let (topMember, stat) = process(inputs: inputs, outputs: outputs, inPopulation: population)

            history.add(fitness: stat.0, error: stat.1)

            if step % 10 == 0 {
                logger.info("Top fitness in step \(step + 1): \(stat.0)")
            }

            guard stat.0 >= parent.fitness && topMember != parent else {
                continue
            }

            parent = topMember
        }

        logger.info("Finished with top fitness \(parent.fitness)")

        return (parent, history)
    }

    // MARK: - Private

    /// Performs a step with a given datasource
    /// - Returns: Best CGP Graph, (Fitness and error)
    @discardableResult
    private func process(inputs: [[Double]], outputs: [Double], inPopulation population: [CGPGraph]) -> (CGPGraph, (Double, Double)) {

        var histories: [[Double]] = (0 ..< population.count).map { _ in [] }

        for input in inputs {

            for (index, member) in population.enumerated() {

                let prediction = member.prediction(for: input).first!

                histories[index].append(prediction)
            }
        }

        let qualities = histories.enumerated().map { index, history -> (Double, Double) in

            let (fitness, error) = fitnessCalculator.calculateFitness(fromPredictions: history, groundTruth: outputs)

            population[index].fitness = fitness

            return (fitness, error)
        }

        let bestFitnessAndError = qualities.max { history1, history2 -> Bool in
            history1.0 < history2.0
        }!

        let best = population[qualities.map(\.0).firstIndex(of: bestFitnessAndError.0)!]

        return (best, bestFitnessAndError)
    }
}
