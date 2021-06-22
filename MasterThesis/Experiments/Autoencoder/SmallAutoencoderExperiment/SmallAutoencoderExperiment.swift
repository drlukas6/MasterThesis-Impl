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
        dateFormatter.timeStyle = .medium

        return dateFormatter

    }()

    private let dataset = SmallAutoEncoderDataSet().dataset

    private let pixels = ImageLoader.loadGrayscale(from: .mnistImage).pixelVector.map { pixel in Double(pixel) }

    private let imageSize = CGSize(width: 4, height: 4)

    func work() -> (CGPGraph, History) {

        let baseDirectory = Self.checkpointsPath.appendingPathComponent("\(name)-\(dateFormatter.string(from: Date()))")

        try! FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true, attributes: nil)


        let features = 2 // 3 kao radi a
        let graph1Build = CGPGraphBuild(inputs: SmallAutoEncoderDataSet.size * SmallAutoEncoderDataSet.size, outputs: features,
                                        levelsBack: 2,
                                        dimension: .init(rows: 6, columns: 10),
                                        operationSet: ImageProcessingCGPEdgeDetectionOperationSet(numberOfInputs: 9))

        let graph2Build = CGPGraphBuild(inputs: features, outputs: SmallAutoEncoderDataSet.size * SmallAutoEncoderDataSet.size,
                                        levelsBack: 2,
                                        dimension: .init(rows: 9, columns: 10),
                                        operationSet: ImageProcessingCGPEdgeDetectionOperationSet(numberOfInputs: 9))

        let (encoder, decoder) = evolve(graph1Build: graph1Build, graph2Build: graph2Build,
                                        truth: dataset,
                                         fitnessCalculator: MSEFitnessCalculator(),
                                         generations: 500,
                                         switchStep: 8,
                                         checkpointHandler: .init(checkpointCallStep: 2, checkpointHandler: { iteration, encoder, decoder in

//                                            for (index, item) in self.dataset.enumerated() {
//
//                                                let encoderOutput = encoder.prediction(for: item)
//                                                let encoderUint8Pixels = encoderOutput.map { pixel in roundDouble(pixel) }
//                                                let encoderImage = Image<UInt8>.init(width: 1, height: features, pixels: encoderUint8Pixels)
//
//
//                                                let size = SmallAutoEncoderDataSet.size
//                                                let decoderOutput = decoder.prediction(for: encoderOutput)
//                                                let decoderUint8Pixels = decoderOutput.map { pixel in UInt8(round(pixel)) }
//                                                let decoderImage = Image<UInt8>(width: size, height: size, pixels: decoderUint8Pixels)
//
//                                                try! ImageHelper.save(image: encoderImage, to: baseDirectory.appendingPathComponent("gen-\(iteration)-\(index)-encoder.png"))
//                                                try! ImageHelper.save(image: decoderImage, to: baseDirectory.appendingPathComponent("gen-\(iteration)-\(index)-decoder.png"))
//
//                                            }
                                         }))

        return (decoder, .init())
    }
}

private func roundDouble(_ double: Double) -> UInt8 {

    guard double != -.infinity else {
        return 0
    }

    guard double != .infinity else {
        return 255
    }

    guard !double.isNaN else {
        return 0
    }

    guard double >= 0 else {
        return 0
    }

    guard double <= 255 else {
        return 255
    }

    return UInt8(double)
}
