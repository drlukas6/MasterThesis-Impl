//
//  SmallAutoencoderExperiment.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 28.04.2021..
//

import Foundation
import SwiftImage
import os.log

private extension URL {

    static let mnistImage = URL.assetsDirectory.appendingPathComponent("mnist_1_4_4.png")
}

class SmallAutoencoderExperiment: Experiment {

    let name = "SmallAutoencoderExperiment"

    private let dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter

    }()

    private let pixels = ImageLoader.loadGrayscale(from: .mnistImage).pixelVector.map { pixel in Double(pixel) }

    private let imageSize = CGSize(width: 4, height: 4)

    func work() -> (CGPGraph, History) {

        let baseDirectory = Self.checkpointsPath.appendingPathComponent("\(name)-\(dateFormatter.string(from: Date()))")

        try! FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)


        let features = 4
        let graph1Build = CGPGraphBuild(inputs: pixels.count, outputs: features,
                                        levelsBack: 2,
                                        dimension: .init(rows: 4, columns: 4),
                                        operationSet: ImageProcessingCGPEdgeDetectionOperationSet())

        let graph2Build = CGPGraphBuild(inputs: features, outputs: pixels.count,
                                        levelsBack: 2,
                                        dimension: .init(rows: pixels.count, columns: 4),
                                        operationSet: ImageProcessingCGPEdgeDetectionOperationSet())

        let (encoder, decoder) = evolve(graph1Build: graph1Build, graph2Build: graph2Build,
                                         truth: pixels,
                                         fitnessCalculator: MSEFitnessCalculator(),
                                         generations: 200,
                                         switchStep: 4,
                                         checkpointHandler: .init(checkpointCallStep: 2, checkpointHandler: { iteration, encoder, decoder in

                                            let encoderOutput = encoder.prediction(for: self.pixels)
                                            let encoderUint8Pixels = encoderOutput.map { pixel in UInt8(round(pixel)) }
                                            let encoderImage = Image<UInt8>.init(width: 1, height: 4, pixels: encoderUint8Pixels)


                                            let decoderOutput = decoder.prediction(for: encoderOutput)
                                            let decoderUint8Pixels = decoderOutput.map { pixel in UInt8(round(pixel)) }
                                            let decoderImage = Image<UInt8>(width: 4, height: 4, pixels: decoderUint8Pixels)

                                            try! ImageHelper.save(image: encoderImage, to: baseDirectory.appendingPathComponent("gen-\(iteration)-encoder.png"))
                                            try! ImageHelper.save(image: decoderImage, to: baseDirectory.appendingPathComponent("gen-\(iteration)-decoder.png"))
                                         }))

        return (decoder, .init())
    }
}
