//
//  TestSymbolicRegressionExperiment.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation
import os.log

class TestSymbolicRegressionExperiment: Experiment {

    private let logger = Logger()

    let name = "TestSymbolicRegressionExperiment"

    var population: CGPPopulation

    init() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 1, outputs: 1, levelsBack: 2,
                                                            dimension: .init(rows: 2, columns: 4),
                                                            operationsSet: DefaultOperationSet())

        population = CGPPopulation(fitnessCalculator: MSEFitnessCalculator(),
                                   graphParameters: graphParameters)
    }

    func start() -> CGPGraph {

        let startDate = Date()



        let datasource = TestSquaredDataSource()

        let best = population.process(withDatasource: datasource, forGenerations: 200)

        let duration = Date().timeIntervalSince(startDate) * 1000

        logger.info("\nExperiment finished in \(duration)ms")

        log(withStatus: .ok)

        return best
    }
}
