//
//  LargeSaltPepperExperiment.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 11.04.2021..
//

import Foundation
import os.log
import SwiftImage
import AppKit

class LargeSaltPepperExperiment: Experiment {

    private let logger = Logger()

    let name = "LargeSaltPepperExperiment"

    private var population: CGPPopulation

    private static let dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter

    }()

    init() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 8, outputs: 1, levelsBack: 20,
                                                            dimension: .init(rows: 2, columns: 20),
                                                            operationsSet: LenaGrainRemovalOperationSet(numberOfInputs: 8))

        population = CGPPopulation(fitnessCalculator: L1FitnessCalculator(),
                                   graphParameters: graphParameters)
    }

    func work() -> (CGPGraph, History) {

        let dataSource = LargeSaltPepperExperimentDataSource()

        let baseDirectory = Self.checkpointsPath.appendingPathComponent("\(name)-\(Self.dateFormatter.string(from: Date()))")

        try! FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)

        let imageWindows = (0 ..< dataSource.fullSize * dataSource.fullSize ).map { row in dataSource.full(at: row) }

        try! ImageHelper.save(image: dataSource.grainedImage, to: baseDirectory.appendingPathComponent("org.png"))

        let (best, history) = population.process(withDatasource: dataSource,
                                                 runParameters: .init(generations: 500, error: 0.005)) { graph, iteration in

            guard iteration % 50 == 0 else {
                return
            }

            let image = Image<UInt8>(width: dataSource.fullSize, height: dataSource.fullSize, pixels: imageWindows.map { window -> UInt8 in UInt8(round(graph.prediction(for: window).first!)) })

            try! ImageHelper.save(image: image, to: baseDirectory.appendingPathComponent("gen-\(iteration).png"))
        }

        return (best, history)
    }
}

