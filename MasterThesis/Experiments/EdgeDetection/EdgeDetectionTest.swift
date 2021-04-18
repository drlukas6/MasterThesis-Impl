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

        let graphParameters = CGPPopulation.GraphParameters(inputs: 9, outputs: 1, levelsBack: 2,
                                                            dimension: .init(rows: 2, columns: 10),
                                                            operationsSet: EdgeDetectionOperationSet())

        population = CGPPopulation(fitnessCalculator: L1FitnessCalculator(),
                                   graphParameters: graphParameters)
    }

    func work() -> (CGPGraph, History) {

        let dataSource = LenaEdgeDetectionDataSource()

        let (best, history) = population.process(withDatasource: dataSource,
                                                 runParameters: .init(generations: 350, error: 0.05))

        let pixels = (0 ..< 512 * 512 ).map { row -> UInt8 in

            let prediction = best.prediction(for: dataSource.full(at: row)).first!

            return UInt8( round(prediction) )
        }

        let image = Image<UInt8>(width: 512, height: 512, pixels: pixels)

        let cgimage = image.cgImage

        return (best, history)
    }
}

