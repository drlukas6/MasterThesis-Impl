//
//  SteadyStateAlgorithm.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 18.04.2021..
//

import Foundation
import os.log

class SteadyStateAlgorithm {

    struct RunParameters {

        let generations: Int
        let error: Double

        let mProbability: Double
    }

    private let logger = Logger()

    private let runParameters: RunParameters
    private var population: Set<CGPGraph>
    private let fitnessCalculator: FitnessCalculator

    init(population: [CGPGraph], runParameters: RunParameters, fitnessCalculator: FitnessCalculator) {

        self.population = Set(population)
        self.runParameters = runParameters

        self.fitnessCalculator = fitnessCalculator
    }

    func work(datasource: Datasource) -> CGPGraph {

//        let history = History()

        var inputs = [[Double]]()
        inputs.reserveCapacity(datasource.size)
//
//        var valInputs = [[Double]]()
//        var valOutputs = [[Double]]()

        var outputs = [Double]()
        outputs.reserveCapacity(datasource.size)

        for row in (0 ..< datasource.size) {

            inputs.append(datasource.input(at: row))
            outputs.append(datasource.output(at: row).first!)

//            guard let valInput = datasource.valInput(at: row),
//                  let valOutput = datasource.valOutput(at: row) else {
//                continue
//            }
//
//            valInputs.append(valInput)
//            valOutputs.append(valOutput)
        }

        var bestMember: CGPGraph?

        for generation in (0 ..< runParameters.generations) {

            for graph in population where graph.fitness == -.infinity {

                let graphOutputs = inputs.map { input in graph.prediction(for: input).first! }

                let (fitness, _) = fitnessCalculator.calculateFitness(fromPredictions: graphOutputs,
                                                                      groundTruth: outputs)

                graph.fitness = fitness

                if bestMember == nil {

                    bestMember = graph

                    continue
                }

                if bestMember!.fitness <= fitness {

                    bestMember = graph
                }
            }

            if generation % 10 == 0 {
                let fitness = bestMember!.fitness
                logger.info("Generation \(generation + 1, align: .left(columns: 5)) F: \(fitness), E: \(1/fitness)")
            }

            let tournamentResult = tournament(selectFrom: population, members: 3)

            // TODO: Sto ako dobijes dva djeteta
            let newMember = CGPGraph.combine(left: tournamentResult[0], right: tournamentResult[1])

            if Double.random(in: (0 ... 1)) <= runParameters.mProbability {
                newMember.mutate()
            }

            population.remove(population.randomElement()!)
            population.insert(newMember)
        }

        return bestMember!
    }

    private func tournament(selectFrom population: Set<CGPGraph>, members: Int) -> [CGPGraph] {

        let sortedPopulation = population.sorted(by: fitnessSort)

        let fitnessSum = sortedPopulation.map(\.fitness).reduce(0, +)

        var set = Set<CGPGraph>()

        while set.count < members {

            var partialSum = Double(0)
            let random = Double.random(in: (0 ... fitnessSum))

            for member in sortedPopulation {

                partialSum += member.fitness

                guard partialSum >= random else {
                    continue
                }

                set.insert(member)

                break
            }
        }

        return [CGPGraph].init(set).sorted(by: fitnessSort)
    }

    private func fitnessSort(lhs: CGPGraph, rhs: CGPGraph) -> Bool {
        lhs.fitness > rhs.fitness
    }
}
