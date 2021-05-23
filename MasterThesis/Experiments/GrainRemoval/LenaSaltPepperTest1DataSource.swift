//
//  LenaSaltPepperTest1DataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import SwiftImage
import AppKit

private extension URL {

    static let lenaSmall = URL.assetsDirectory.appendingPathComponent("lena_256.jpg")
    static let lenaC = URL.assetsDirectory.appendingPathComponent("lena.png")
    static let lena = URL.assetsDirectory.appendingPathComponent("lena_salt_pepper.png")
    static let cameraman = URL.assetsDirectory.appendingPathComponent("cameraman.jpg")
}

private extension Int {

    static let windowSize = 30
    static let windowHalfStep = windowSize / 2
}

struct LenaSaltPepperTest1DataSource: Datasource {

    private let lenaImage: Image<UInt8> = ImageLoader.loadGrayscale(from: .lenaSmall)
    private let lenaCleanImage: Image<UInt8> = ImageLoader.loadGrayscale(from: .lenaSmall)
    private let cameramanImage: Image<UInt8> = ImageLoader.loadGrayscale(from: .cameraman)

    private let grainedImage: Image<UInt8>
    private let grainedValImage: Image<UInt8>

    private let inputImage: ImageSlice<UInt8>
    private let outputImage: ImageSlice<UInt8>

    private let inputValImage: ImageSlice<UInt8>
    private let outputValImage: ImageSlice<UInt8>

    var fullIm: Image<UInt8> {
        grainedImage
    }

    var fullSize: Int {
        lenaImage.width
    }
//    let fullSize = 256

    let size: Int = .windowSize * .windowSize

    init(grain: Double = 0.05) {

//        grainedImage = lenaImage
        grainedImage = lenaImage.map { pixel in

            guard Double.random(in: 0 ..< 1) > grain else {

                return Bool.random() ? .black : .white
            }

            return pixel
        }

        grainedValImage = cameramanImage.map { pixel in

            guard Double.random(in: 0 ..< 1) > grain else {

                return Bool.random() ? .black : .white
            }

            return pixel
        }

//        let (centerX, centerY) = (grainedImage.width / 2, grainedImage.height / 2)

//        let (centerX, centerY) = (300, 330)
        let (centerX, centerY) = (161, 178)
//        let (centerX, centerY) = (37, 18)
//
        let (centerXVal, centerYVal) = (grainedValImage.width / 2, grainedValImage.height / 2)

        inputImage = grainedImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                                  centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        outputImage = lenaCleanImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                                centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        let quarterXVal = grainedImage.width / 4

        inputValImage = grainedValImage[centerXVal - .windowHalfStep ..< centerXVal + .windowHalfStep,
                                        centerYVal - .windowHalfStep ..< centerYVal + .windowHalfStep]

        outputValImage = cameramanImage[centerXVal - .windowHalfStep ..< centerXVal + .windowHalfStep,
                                        centerYVal - .windowHalfStep ..< centerYVal + .windowHalfStep]

        let im1 = NSImage(cgImage: inputImage.cgImage, size: .init(width: 40, height: 40))
        let im2 = NSImage(cgImage: outputImage.cgImage, size: .init(width: 40, height: 40))
        let im3 = NSImage(cgImage: inputValImage.cgImage, size: .init(width: 40, height: 40))
        let im4 = NSImage(cgImage: outputValImage.cgImage, size: .init(width: 40, height: 40))
//
        print()
    }

    func full(at index: Int) -> [Double] {

        let row = index / grainedImage.width
        let column = index % grainedImage.width

        return grainedImage.window(forPixelAt: (x: column, y: row), takeCenter: false)
                           .vector
                           .map { Double($0) }
    }

    func fullVal(at index: Int) -> [Double] {

        let row = index / grainedValImage.width
        let column = index % grainedValImage.width

        return grainedValImage.window(forPixelAt: (x: column, y: row), takeCenter: false)
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
