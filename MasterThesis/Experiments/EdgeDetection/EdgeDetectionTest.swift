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

    private static let dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter

    }()

    init() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 9, outputs: 1, levelsBack: 2,
                                                            dimension: .init(rows: 2, columns: 10),
                                                            operationsSet: EdgeDetectionOperationSet()) // EDGE DAJE OK REZ

        population = CGPPopulation(fitnessCalculator: MSEFitnessCalculator(),
                                   graphParameters: graphParameters,
                                   populationSize: 8)
    }

    func work() -> (CGPGraph, History) {

        let dataSource = LenaEdgeDetectionDataSource()

        let baseDirectory = Self.checkpointsPath.appendingPathComponent("\(name)-\(Self.dateFormatter.string(from: Date()))")

        try! FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)

        let imageWindows = (0 ..< 256 * 256 ).map { row in dataSource.full(at: row) }
        let cameramanWindows = (0 ..< 256 * 256 ).map { row in dataSource.fullCameraman(at: row) }

        let (best, history) = population.process(withDatasource: dataSource,
                                                 runParameters: .init(generations: 25, error: 0.04)) { graph, iteration in

            let image = Image<UInt8>(width: 256, height: 256, pixels: imageWindows.map { window -> UInt8 in UInt8(round(graph.prediction(for: window).first!)) })
            let imageVal = Image<UInt8>(width: 256, height: 256, pixels: cameramanWindows.map { window -> UInt8 in UInt8(round(graph.prediction(for: window).first!)) })

            try! ImageHelper.save(image: image, to: baseDirectory.appendingPathComponent("gen-\(iteration).png"))
            try! ImageHelper.save(image: imageVal, to: baseDirectory.appendingPathComponent("val-gen-\(iteration).png"))
        }

        let bestPixels = imageWindows.map { window -> UInt8 in UInt8(round(best.prediction(for: window).first!)) }

        let image = Image<UInt8>(width: 256, height: 256, pixels: bestPixels)

        let cgimage = image.cgImage
        print(cgimage.bitsPerComponent)
        return (best, history)
    }

    func work2() {

        let graphParameters = CGPPopulation.GraphParameters(inputs: 9, outputs: 1, levelsBack: 2,
                                                            dimension: .init(rows: 2, columns: 10),
                                                            operationsSet: ImageProcessingCGPEdgeDetectionOperationSet())

        let population = CGPPopulation(fitnessCalculator: MSEFitnessCalculator(),
                                       graphParameters: graphParameters,
                                       populationSize: 400)

        let dataSource = LenaEdgeDetectionDataSource()

        let algorithm = SteadyStateAlgorithm(population: population.population,
                                             runParameters: .init(generations: 250, error: 0.05,
                                                                  mProbability: 0.1),
                                             fitnessCalculator: MAEFitnessCalculator())

        let best = algorithm.work(datasource: dataSource)

        let pixels = (0 ..< 256 * 256 ).map { row -> UInt8 in

            let prediction = best.prediction(for: dataSource.full(at: row)).first!

            return UInt8( round(prediction) )
        }

        let image = Image<UInt8>(width: 256, height: 256, pixels: pixels)

        let cgimage = image.cgImage

        print(cgimage.bitsPerComponent)
    }
}

