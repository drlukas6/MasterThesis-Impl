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

    private static let dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter

    }()

    init() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 8, outputs: 1, levelsBack: 2,
                                                            dimension: .init(rows: 2, columns: 10),
                                                            operationsSet: ImageProcessingCGPEdgeDetectionOperationSet(numberOfInputs: 8))

        population = CGPPopulation(fitnessCalculator: L1FitnessCalculator(),
                                   graphParameters: graphParameters)
    }

    func work() -> (CGPGraph, History) {

        let dataSource = LenaSaltPepperTest1DataSource()

        let baseDirectory = Self.checkpointsPath.appendingPathComponent("\(name)-\(Self.dateFormatter.string(from: Date()))")

        try! FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)

        let imageWindows = (0 ..< 256 * 256 ).map { row in dataSource.full(at: row) }
        let valWindows = (0 ..< 256 * 256 ).map { row in dataSource.fullVal(at: row) }

        try! ImageHelper.save(image: dataSource.fullIm, to: baseDirectory.appendingPathComponent("org.png"))

        let (best, history) = population.process(withDatasource: dataSource,
                                                 runParameters: .init(generations: 600, error: 0.005)) { graph, iteration in

            guard iteration % 30 == 0 else {
                return
            }

            let image = Image<UInt8>(width: 256, height: 256, pixels: imageWindows.map { window -> UInt8 in UInt8(round(graph.prediction(for: window).first!)) })
            let imageVal = Image<UInt8>(width: 256, height: 256, pixels: valWindows.map { window -> UInt8 in UInt8(round(graph.prediction(for: window).first!)) })

            try! ImageHelper.save(image: image, to: baseDirectory.appendingPathComponent("gen-\(iteration).png"))
            try! ImageHelper.save(image: imageVal, to: baseDirectory.appendingPathComponent("val-gen-\(iteration).png"))
        }

        let bestPixels = imageWindows.map { window -> UInt8 in UInt8(round(best.prediction(for: window).first!)) }

        let image = Image<UInt8>(width: 256, height: 256, pixels: bestPixels)

        let cgimage = image.cgImage
        print(cgimage.bitsPerComponent)
        return (best, history)
    }
}

