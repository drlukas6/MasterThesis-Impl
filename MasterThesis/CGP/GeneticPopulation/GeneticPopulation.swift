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
    }

    struct PopulationParameters {

        let fitnessCalculator: FitnessCalculator
    }

    private let logger = Logger()

    var population: [CGPGraph]

    var best: CGPGraph {

        population
            .sorted(by: { $0.fitness < $1.fitness})
            .last!
    }

    private let fitnessCalculator: FitnessCalculator
    private let graphParameters: GraphParameters

    init(fitnessCalculator: FitnessCalculator, graphParameters: GraphParameters) {

        self.fitnessCalculator = fitnessCalculator
        self.graphParameters = graphParameters

        population = (0 ..< 4).compactMap { _ in CGPGraph(inputs: graphParameters.inputs,
                                                          outputs: graphParameters.outputs,
                                                          levelsBack: graphParameters.levelsBack,
                                                          dimension: graphParameters.dimension) }
    }

    /// Processes a whole dataset for the given number of generations and returns the
    /// best performing CGPGraph
    func process(withDatasource datasource: Datasource, forGenerations generations: Int) -> CGPGraph {

        process(datasource: datasource, inPopulation: population)

        logger.info("Calculated fitnesses: \(self.population.map(\.fitness))")

        var parent = population.sorted { (lhs, rhs) -> Bool in
            lhs.fitness < rhs.fitness
        }.last!

        logger.info("Best fitness: \(parent.fitness)")

        for step in (0 ..< generations) {

            logger.info("Entering step \(step + 1)")

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
    private func process(datasource: Datasource, inPopulation population: [CGPGraph]) -> (CGPGraph, Double){

        var topMember = population.first!
        var topFitness = -Double.infinity

        for member in population {

            let memberPredictions = (0 ..< datasource.size).map { row -> Double in

                let input  = datasource.input(at: row)

                let memberPrediction = member.prediction(for: input).first!

                return memberPrediction
            }

            let truth = datasource.outputs.map { $0.first! }

            let calculatedFitness = fitnessCalculator.calculateFitness(fromPredictions: memberPredictions,
                                                                       groundTruth: truth)

            logger.info("Calculated fitness: \(calculatedFitness)")

            member.fitness = calculatedFitness

            if calculatedFitness >= topFitness {
                topMember = member
                topFitness = calculatedFitness
            }
        }

        return (topMember, topFitness)
    }
}
