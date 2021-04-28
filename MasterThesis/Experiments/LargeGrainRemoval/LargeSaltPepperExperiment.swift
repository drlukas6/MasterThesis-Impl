//
//  LargeSaltPepperExperiment.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 11.04.2021..
//

import Foundation
import os.log
import SwiftImage

class LargeSaltPepperExperiment: Experiment {

    private let logger = Logger()

    let name = "LargeSaltPepperExperiment"

    private var population: CGPPopulation

    init() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 8, outputs: 1, levelsBack: 20,
                                                            dimension: .init(rows: 2, columns: 20),
                                                            operationsSet: LenaGrainRemovalOperationSet(numberOfInputs: 8))

        population = CGPPopulation(fitnessCalculator: L1FitnessCalculator(),
                                   graphParameters: graphParameters)
    }

    func work() -> (CGPGraph, History) {

        let dataSource = LargeSaltPepperExperimentDataSource()

        let (best, history) = population.process(withDatasource: dataSource,
                                                 runParameters: .init(generations: 600, error: 0.005))

        let pixels = (0 ..< dataSource.fullSize * dataSource.fullSize).map { row -> UInt8 in

            let prediction = best.prediction(for: dataSource.full(at: row)).first!

            return UInt8( round(prediction) )
        }

        let image = Image<UInt8>(width: dataSource.fullSize, height: dataSource.fullSize, pixels: pixels)

        let cgimage = image.cgImage

        print(cgimage.bitsPerComponent)

        return (best, history)
    }
}

