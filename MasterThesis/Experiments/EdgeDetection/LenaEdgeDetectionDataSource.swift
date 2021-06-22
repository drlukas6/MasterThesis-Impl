//
//  LenaEdgeDetectionDataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 01.04.2021..
//

import Foundation
import SwiftImage
import AppKit

private extension URL {

    static let lena = URL.assetsDirectory.appendingPathComponent("lena_256.jpg")
    static let cameraman = URL.assetsDirectory.appendingPathComponent("cameraman.jpg")

    static let cannyLena = URL.assetsDirectory.appendingPathComponent("lenacanny-full-256.jpg")
    static let cannyCameraman = URL.assetsDirectory.appendingPathComponent("cameraman_canny.jpg")
}

private extension Int {

    static let windowSize = 40
    static let windowHalfStep = windowSize / 2
}


struct LenaEdgeDetectionDataSource: Datasource {

    private let lenaImage = ImageLoader.loadGrayscale(from: .lena)
    private let cameramanImage = ImageLoader.loadGrayscale(from: .cameraman)

    private let cannyLenaImage = ImageLoader.loadGrayscale(from: .cannyLena)
    private let cannyCameramanImage = ImageLoader.loadGrayscale(from: .cannyCameraman)

    private let inputImage: ImageSlice<UInt8>
    private let outputImage: ImageSlice<UInt8>

    private let inputValImage: ImageSlice<UInt8>
    private let outputValImage: ImageSlice<UInt8>

    let size: Int = .windowSize * .windowSize

    init() {

        let (centerX, centerY) = (135, 115)
        let (centerXV, centerYV) = (133, 66)

        let quarterXVal = lenaImage.width / 4

        inputImage = lenaImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                               centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        outputImage = cannyLenaImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                                     centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        inputValImage = cameramanImage[centerXV - .windowHalfStep ..< centerXV + .windowHalfStep,
                                       centerYV - .windowHalfStep ..< centerYV + .windowHalfStep]

        outputValImage = cannyCameramanImage[centerXV - .windowHalfStep ..< centerXV + .windowHalfStep,
                                             centerYV - .windowHalfStep ..< centerYV + .windowHalfStep]

        let im1 = inputImage.cgImage
        let im2 = outputImage.cgImage
        let im3 = inputValImage.cgImage
        let im4 = outputValImage.cgImage

        let im11 = NSImage(cgImage: im1, size: .init(width: 40, height: 40))
        let im12 = NSImage(cgImage: im2, size: .init(width: 40, height: 40))
        let im13 = NSImage(cgImage: im3, size: .init(width: 40, height: 40))
        let im14 = NSImage(cgImage: im4, size: .init(width: 40, height: 40))

        print()
    }

    func full(at index: Int) -> [Double] {

        let row = index / lenaImage.width
        let column = index % lenaImage.width

        return lenaImage.window(forPixelAt: (x: column, y: row), takeCenter: true)
                        .vector
                        .map { Double($0) }
    }

    func fullCameraman(at index: Int) -> [Double] {

        let row = index / cameramanImage.width
        let column = index % cameramanImage.width

        return cameramanImage.window(forPixelAt: (x: column, y: row), takeCenter: true)
                             .vector
                             .map { Double($0) }
    }

    func input(at index: Int) -> [Double] {

        let index = index % (Int.windowSize * Int.windowSize)

        let row = index / (inputImage.width)
        let column = index % inputImage.width

        return inputImage.window(forPixelAt: (x: column, y: row), takeCenter: true)
                         .vector
                         .map { Double($0) }
    }

    func output(at index: Int) -> [Double] {

        let index = index % (Int.windowSize * Int.windowSize)

        let row = index / outputImage.width
        let column = index % outputImage.width

        return [Double(outputImage[column + outputImage.xRange.startIndex,
                                   row + outputImage.yRange.startIndex])]
    }

    func valInput(at index: Int) -> [Double]? {

        let row = index / inputValImage.width
        let column = index % inputValImage.width

        return inputValImage.window(forPixelAt: (x: column, y: row), takeCenter: true)
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
