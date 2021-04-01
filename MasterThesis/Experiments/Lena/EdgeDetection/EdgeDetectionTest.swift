//
//  EdgeDetectionTest.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 01.04.2021..
//

import Foundation
import os.log
import SwiftImage

class EdgeDetectionTest: Experiment {

    private let logger = Logger()

    let name = "EdgeDetectionTestExperiment"

    private var population: CGPPopulation

    init() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 9, outputs: 1, levelsBack: 4,
                                                            dimension: .init(rows: 2, columns: 15),
                                                            operationsSet: LenaOperationSet(numberOfInputs: 9))

        population = CGPPopulation(fitnessCalculator: L1FitnessCalculator(),
                                   graphParameters: graphParameters)
    }

    func work() -> (CGPGraph, History) {

        let dataSource = LenaEdgeDetectionDataSource()

        let (best, history) = population.process(withDatasource: dataSource,
                                           forGenerations: 1500)

        let pixels = (0 ..< dataSource.size).map { row -> UInt8 in

            let prediction = best.prediction(for: dataSource.input(at: row)).first!

            return UInt8( round(prediction) )
        }

        let pixels2 = (0 ..< dataSource.fullSize).map { row -> UInt8 in

            let prediction = best.prediction(for: dataSource.full(at: row)).first!

            return UInt8( round(prediction) )
        }

        let image = Image<UInt8>(width: dataSource.fullW, height: dataSource.fullH, pixels: pixels2)

        let cgimage = image.cgImage

        return (best, history)
    }
}

