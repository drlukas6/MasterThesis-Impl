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
                                                            dimension: .init(rows: 4, columns: 8),
                                                            operationsSet: EdgeDetectionOperationSet())

        population = CGPPopulation(fitnessCalculator: L1FitnessCalculator(),
                                   graphParameters: graphParameters,
                                   populationSize: 8)
    }

    func work() -> (CGPGraph, History) {

        let dataSource = LenaEdgeDetectionDataSource()

        let baseDirectory = Self.checkpointsPath.appendingPathComponent("\(name)-\(Self.dateFormatter.string(from: Date()))")

        try! FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)

        let imageWindows = (0 ..< 512 * 512 ).map { row in dataSource.full(at: row) }

        let (best, history) = population.process(withDatasource: dataSource,
                                                 runParameters: .init(generations: 2000, error: 0.04)) { graph, iteration in

            let image = Image<UInt8>(width: 512, height: 512, pixels: imageWindows.map { window -> UInt8 in UInt8(round(graph.prediction(for: window).first!)) })

            try! ImageHelper.save(image: image, to: baseDirectory.appendingPathComponent("gen-\(iteration).png"))
        }

        let bestPixels = imageWindows.map { window -> UInt8 in UInt8(round(best.prediction(for: window).first!)) }
//            .map { row -> UInt8 in
//
//            let prediction = best.prediction(for: dataSource.full(at: row)).first!
//
//            return UInt8( round(prediction) )
//        }


        let image = Image<UInt8>(width: 512, height: 512, pixels: bestPixels)

        let cgimage = image.cgImage
        print(cgimage.bitsPerComponent)
        return (best, history)
    }

    func work2() {

        let dataSource = LenaEdgeDetectionDataSource()

        let algorithm = SteadyStateAlgorithm(population: population.population,
                                             runParameters: .init(generations: 250, error: 0.05,
                                                                  mProbability: 0.1),
                                             fitnessCalculator: L1FitnessCalculator())

        let best = algorithm.work(datasource: dataSource)

        let pixels = (0 ..< 512 * 512 ).map { row -> UInt8 in

            let prediction = best.prediction(for: dataSource.full(at: row)).first!

            return UInt8( round(prediction) )
        }

        let image = Image<UInt8>(width: 512, height: 512, pixels: pixels)

        let cgimage = image.cgImage

        print(cgimage.bitsPerComponent)
    }
}

