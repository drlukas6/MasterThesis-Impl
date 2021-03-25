//
//  SaltPepperTest.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import os.log

class SaltPepperTest: Experiment {

    private let logger = Logger()

    let name = "SaltPepperTestExperiment"

    private var population: CGPPopulation

    init() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 8, outputs: 1, levelsBack: 2,
                                                            dimension: .init(rows: 2, columns: 10),
                                                            operationsSet: LenaOperationSet(numberOfInputs: 8))

        population = CGPPopulation(fitnessCalculator: MSEFitnessCalculator(),
                                   graphParameters: graphParameters)
    }

    func work() -> CGPGraph {

        population.process(withDatasource: LenaSaltPepperTest1DataSource(),
                           forGenerations: 400)
    }
}

