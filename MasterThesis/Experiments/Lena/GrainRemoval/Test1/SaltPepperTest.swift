//
//  SaltPepperTest.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import os.log
import SwiftImage

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

        let dataSource = LenaSaltPepperTest1DataSource()

        let best = population.process(withDatasource: dataSource,
                                      forGenerations: 1000)

        let pixels = (0 ..< dataSource.size).map { row -> UInt8 in

            let prediction = best.prediction(for: dataSource.input(at: row)).first!

            return UInt8( round(prediction) )
        }

        let image = Image<UInt8>(width: 30, height: 30, pixels: pixels)

        let cgimage = image.cgImage

        return best
    }
}

