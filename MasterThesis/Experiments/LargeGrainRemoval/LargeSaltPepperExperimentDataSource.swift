//
//  LargeSaltPepperExperimentDataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 11.04.2021..
//

import Foundation
import SwiftImage

private extension URL {

    static let lena = URL.assetsDirectory.appendingPathComponent("lena_512.jpg")
}

private extension Int {

    static let windowSize = 30
    static let windowHalfStep = windowSize / 2
}

struct LargeSaltPepperExperimentDataSource: Datasource {

    private let lenaImage: Image<UInt8> = ImageLoader.loadGrayscale(from: .lena)
    let grainedImage: Image<UInt8>

    private let inputImage: ImageSlice<UInt8>
    private let outputImage: ImageSlice<UInt8>

    private let inputValImage: ImageSlice<UInt8>
    private let outputValImage: ImageSlice<UInt8>

    let fullSize = 512

    let size: Int = .windowSize * .windowSize

    init(grain: Double = 0.4) {

        grainedImage = lenaImage.map { pixel in

            guard Double.random(in: 0 ..< 1) > grain else {

                return Bool.random() ? .black : .white
            }

            return pixel
        }

        let (centerX, centerY) = (grainedImage.width / 2, grainedImage.height / 2)

        inputImage = grainedImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                                  centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        outputImage = lenaImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                                centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        let quarterXVal = grainedImage.width / 4

        inputValImage = grainedImage[quarterXVal - .windowHalfStep ..< quarterXVal + .windowHalfStep,
                                     centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        outputValImage = lenaImage[quarterXVal - .windowHalfStep ..< quarterXVal + .windowHalfStep,
                                   centerY - .windowHalfStep ..< centerY + .windowHalfStep]
    }

    func full(at index: Int) -> [Double] {

        let row = index / grainedImage.width
        let column = index % grainedImage.width

        return grainedImage.window(forPixelAt: (x: column, y: row), takeCenter: false)
                           .vector
                           .map { Double($0) }
    }

    func input(at index: Int) -> [Double] {

        let row = index / inputImage.width
        let column = index % inputImage.width

        return inputImage.window(forPixelAt: (x: column, y: row), takeCenter: false)
                         .vector
                         .map { Double($0) }
    }

    func output(at index: Int) -> [Double] {

        let row = index / outputImage.width
        let column = index % outputImage.width

        return [Double(outputImage[column + outputImage.xRange.startIndex,
                                   row + outputImage.yRange.startIndex])]
    }

    func valInput(at index: Int) -> [Double]? {

        let row = index / inputValImage.width
        let column = index % inputValImage.width

        return inputValImage.window(forPixelAt: (x: column, y: row), takeCenter: false)
                            .vector
                            .map { Double($0) }
    }


    func valOutput(at index: Int) -> [Double]? {

        let row = index / outputValImage.width
        let column = index % outputValImage.width

        return [Double(outputValImage[column + outputValImage.xRange.startIndex,
                                      row + outputValImage.yRange.startIndex])]
    }
}
