//
//  LenaEdgeDetectionDataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 01.04.2021..
//

import Foundation
import SwiftImage

private extension URL {

    static let lena = URL.assetsDirectory.appendingPathComponent("lena_512.jpg")
    static let cannyLena = URL.assetsDirectory.appendingPathComponent("lenacanny-full.jpg")
//    static let cannyLena = URL.assetsDirectory.appendingPathComponent("lena_edges.png")
//    static let cannyLena = URL.assetsDirectory.appendingPathComponent("lena_edges3.png")
//        static let cannyLena = URL.assetsDirectory.appendingPathComponent("lena_edges2.png")
}

private extension Int {

//    static let windowSize = 30
    static let windowSize = 30
//    static let windowSize = 50
    static let windowHalfStep = windowSize / 2
}


struct LenaEdgeDetectionDataSource: Datasource {

    private let lenaImage = ImageLoader.loadGrayscale(from: .lena)
    private let cannyLenaImage = ImageLoader.loadGrayscale(from: .cannyLena)

    private let inputImage: ImageSlice<UInt8>
    private let outputImage: ImageSlice<UInt8>

    private let inputValImage: ImageSlice<UInt8>
    private let outputValImage: ImageSlice<UInt8>

    let size: Int = .windowSize * .windowSize

    init() {

//        let (centerX, centerY) = (lenaImage.width / 2, lenaImage.height / 2)
        let (centerX, centerY) = (132, 238)
//        let (centerX, centerY) = (344, 144)
//        let (centerX, centerY) = (193, 317)
//        let (centerX, centerY) = (163, 410)

        let quarterXVal = lenaImage.width / 4
        let yVal = Int(Double(lenaImage.height) / 1.98)

//        inputImage = lenaImage[163 - .windowHalfStep ..< 163 + .windowHalfStep,
//                               312 - .windowHalfStep ..< 312 + .windowHalfStep]
//
//        let ccc = inputImage.cgImage
//
//        outputImage = cannyLenaImage[163 - .windowHalfStep ..< 163 + .windowHalfStep,
//                                     312 - .windowHalfStep ..< 312 + .windowHalfStep]
//
//        let ccc2 = outputImage.cgImage

        inputImage = lenaImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                               centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        let ccc = inputImage.cgImage

        outputImage = cannyLenaImage[centerX - .windowHalfStep ..< centerX + .windowHalfStep,
                                     centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        let ccc2 = outputImage.cgImage

        inputValImage = lenaImage[quarterXVal - .windowHalfStep ..< quarterXVal + .windowHalfStep,
                                  centerY - .windowHalfStep ..< centerY + .windowHalfStep]

        outputValImage = cannyLenaImage[quarterXVal - .windowHalfStep ..< quarterXVal + .windowHalfStep,
                                        centerY - .windowHalfStep ..< centerY + .windowHalfStep]
    }

    func full(at index: Int) -> [Double] {

        let row = index / lenaImage.width
        let column = index % lenaImage.width

        return lenaImage.window(forPixelAt: (x: column, y: row), takeCenter: true)
                        .vector
                        .map { Double($0) }
    }

    func input(at index: Int) -> [Double] {

        let row = index / inputImage.width
        let column = index % inputImage.width

        return inputImage.window(forPixelAt: (x: column, y: row), takeCenter: true)
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
