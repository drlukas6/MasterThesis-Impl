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

        let populationSize: Int
        let mutationRate: Double
        let fitnessCalculator: FitnessCalculator
        let datasource: Datasource
    }

    private let logger = Logger()

    var population: [CGPGraph]

    var best: CGPGraph {

        population
            .sorted(by: { $0.fitness < $1.fitness})
            .last!
    }

    private let populationParameters: PopulationParameters
    private let graphParameters: GraphParameters

    init(populationParameters: PopulationParameters, graphParameters: GraphParameters) {

        self.populationParameters = populationParameters
        self.graphParameters = graphParameters

        population = (0 ..< 4).compactMap { _ in CGPGraph(inputs: graphParameters.inputs,
                                                          outputs: graphParameters.outputs,
                                                          levelsBack: graphParameters.levelsBack,
                                                          dimension: graphParameters.dimension) }
    }

    func process(generations: Int) {

        for member in population {

            let memberPredictions = (0 ..< populationParameters.datasource.size).map { row -> Double in

                let input  = populationParameters.datasource.input(at: row)

                let memberPrediction = member.prediction(for: input).first!

                return memberPrediction
            }

            let truth = populationParameters.datasource.outputs.map { $0.first! }

            let calculatedFitness = populationParameters.fitnessCalculator.calculateFitness(fromPredictions: memberPredictions, groundTruth: truth)

            logger.info("Calculated fitness: \(calculatedFitness)")

            member.fitness = calculatedFitness
        }

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

            for member in self.population {

                let memberPredictions = (0 ..< populationParameters.datasource.size).map { row -> Double in

                    let input  = populationParameters.datasource.input(at: row)

                    let memberPrediction = member.prediction(for: input).first!

                    return memberPrediction
                }

                let truth = populationParameters.datasource.outputs.map { $0.first! }

                let calculatedFitness = populationParameters.fitnessCalculator.calculateFitness(fromPredictions: memberPredictions, groundTruth: truth)

                logger.info("Calculated fitness in step \(step + 1): \(calculatedFitness)")

                member.fitness = calculatedFitness

                if calculatedFitness >= parent.fitness {

                    logger.info("Setting fitness \(calculatedFitness) as parent")
                    parent = member
                }
            }
        }

        logger.info("Finished with fitness \(parent.fitness)")
    }
}
