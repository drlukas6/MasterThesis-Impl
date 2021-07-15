//
//  LargeAutoencoderExperiment.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 13.07.2021..
//

import Foundation
import SwiftImage

class LargeAutoencoderExperiment: Experiment {

    let name = "LargeAutoencoderExperiment"

    private let dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium

        return dateFormatter

    }()

    private let dataset = LargeAutoEncoderDataSet().dataset

    private let imageSize = CGSize(width: 4, height: 4)

    func work() -> (CGPGraph, History) {

        let baseDirectory = Self.checkpointsPath.appendingPathComponent("\(name)-\(dateFormatter.string(from: Date()))")

        try! FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)


        let features = 6 // 3 kao radi a
        let graph1Build = CGPGraphBuild(inputs: LargeAutoEncoderDataSet.size * LargeAutoEncoderDataSet.size, outputs: features,
                                        levelsBack: 2,
                                        dimension: .init(rows: 6, columns: 10),
                                        operationSet: ImageProcessingCGPEdgeDetectionOperationSet(numberOfInputs: 16))

        let graph2Build = CGPGraphBuild(inputs: features, outputs: LargeAutoEncoderDataSet.size * LargeAutoEncoderDataSet.size,
                                        levelsBack: 2,
                                        dimension: .init(rows: 9, columns: 10),
                                        operationSet: ImageProcessingCGPEdgeDetectionOperationSet(numberOfInputs: 16))

        let (encoder, decoder) = evolve(graph1Build: graph1Build, graph2Build: graph2Build,
                                        truth: dataset,
                                         fitnessCalculator: MSEFitnessCalculator(),
                                         generations: 500,
                                         switchStep: 8,
                                         checkpointHandler: .init(checkpointCallStep: 2, checkpointHandler: { iteration, encoder, decoder in

                                            guard iteration % 20 == 0 else {
                                                return
                                            }

                                            for (index, item) in self.dataset.enumerated() {

                                                let encoderOutput = encoder.prediction(for: item)
                                                let encoderUint8Pixels = encoderOutput.map { pixel in roundDouble(pixel) }
                                                let encoderImage = Image<UInt8>.init(width: 1, height: features, pixels: encoderUint8Pixels)


                                                let size = LargeAutoEncoderDataSet.size
                                                let decoderOutput = decoder.prediction(for: encoderOutput)
                                                let decoderUint8Pixels = decoderOutput.map { pixel in UInt8(round(pixel)) }
                                                let decoderImage = Image<UInt8>(width: size, height: size, pixels: decoderUint8Pixels)

                                                try! ImageHelper.save(image: encoderImage, to: baseDirectory.appendingPathComponent("gen-\(iteration)-\(index)-encoder.png"))
                                                try! ImageHelper.save(image: decoderImage, to: baseDirectory.appendingPathComponent("gen-\(iteration)-\(index)-decoder.png"))
                                            }
                                         }))

        return (decoder, .init())
    }
}
