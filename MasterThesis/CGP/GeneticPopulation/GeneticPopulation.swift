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

    struct RunParameters {

        let generations: Int
        let error: Double
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
    func process(withDatasource datasource: Datasource, runParameters: RunParameters) -> (CGPGraph, History) {

        let history = History()

        var inputs = [[Double]]()
        inputs.reserveCapacity(datasource.size)

        var valInputs = [[Double]]()
        var valOutputs = [[Double]]()

        var lastValError = Double.infinity

        var outputs = [Double]()
        outputs.reserveCapacity(datasource.size)

        for row in (0 ..< datasource.size) {

            inputs.append(datasource.input(at: row))
            outputs.append(datasource.output(at: row).first!)

            guard let valInput = datasource.valInput(at: row),
                  let valOutput = datasource.valOutput(at: row) else {
                continue
            }

            valInputs.append(valInput)
            valOutputs.append(valOutput)
        }

        var (parent, result, _) = process(inputs: inputs, outputs: outputs, inPopulation: population)

        logger.info("Min error: \(result.1)")

        var debuggerBreak = false

        for step in (0 ..< runParameters.generations) {

            guard !debuggerBreak else {
                break
            }

            self.population = [parent] + (0 ..< 4).map { _ in
                parent.mutated()
            }

            let (topMember, stat, _) = process(inputs: inputs, outputs: outputs, inPopulation: population)

            history.add(fitness: stat.0, error: stat.1)

            if !valInputs.isEmpty {

                let (_, valError) = fitnessCalculator.calculateFitness(fromPredictions: valInputs.map { input in topMember.prediction(for: input).first! },
                                                                       groundTruth: valOutputs.map(\.first!))

                history.add(valError: valError)

//                guard valError <= lastValError else {
//
//                    logger.info("Validation error started growing \(lastValError) -> \(valError)")
//
//                    break
//                }

                lastValError = valError
            }

            if step % 10 == 0 {
                logger.info("Error in step \(step + 1): \(stat.1)")
            }

            guard stat.1 >= runParameters.error else {
                break
            }

            guard stat.0 >= parent.fitness && topMember != parent else {
                continue
            }

            parent = topMember
        }

        logger.info("Finished with error \(history.errors.last!)")

        return (parent, history)
    }

    // MARK: - Private

    /// Performs a step with a given datasource
    /// - Returns: Best CGP Graph, (Fitness and error)
    @discardableResult
    private func process(inputs: [[Double]],
                         outputs: [Double],
                         valInputOutputPair: ([Double], [Double])? = nil,
                         inPopulation population: [CGPGraph]) -> (CGPGraph, (Double, Double), Double?) {

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

        return (best, bestFitnessAndError, nil)
    }
}
