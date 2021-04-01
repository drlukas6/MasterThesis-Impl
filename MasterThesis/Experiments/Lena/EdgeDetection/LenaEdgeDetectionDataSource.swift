//
//  LenaEdgeDetectionDataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 01.04.2021..
//

import Foundation
import SwiftImage

private extension URL {

    static let lenaSmallUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_512_slice.jpg")!
    static let lenaSmallEdgeUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_Edge_slice.png")!

    static let lenaEdgesUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_edges.png")!
}

struct LenaEdgeDetectionDataSource: Datasource {

    private static let fullImage: Image<RGB<UInt8>>! = ImageLoader.load(from: .lenaEdgesUrl)

    private static let inputImage: Image<RGB<UInt8>>! = ImageLoader.load(from: .lenaSmallEdgeUrl)
    private static let outputImage: Image<RGB<UInt8>>! = ImageLoader.load(from: .lenaSmallUrl)

    private static let inputGrayscaleImage: Image<UInt8> = inputImage.map { $0.gray }
    private static let outputGrayscaleImage: Image<UInt8> = outputImage.map { $0.gray }

    static let fullGrayscaleImage: Image<UInt8> = fullImage.map { $0.gray }

    static let fullCG = fullGrayscaleImage.cgImage
    static let inputCG = inputImage.cgImage
    static let outputCG = outputImage.cgImage

    let size: Int = 1600

    let fullW = fullGrayscaleImage.width
    let fullH = fullGrayscaleImage.height

    let fullSize: Int = fullGrayscaleImage.width * fullGrayscaleImage.height

    func full(at index: Int) -> [Double] {

        let row = index / Self.fullGrayscaleImage.width
        let column = index % Self.fullGrayscaleImage.width

        return Self.fullGrayscaleImage
                   .window(forPixelAt: (x: column, y: row), takeCenter: true)
                   .vector
                   .map { Double($0) }
    }

    func input(at index: Int) -> [Double] {

        let fullCG = Self.fullGrayscaleImage.cgImage
        let inputCG = Self.inputImage.cgImage
        let outputCG = Self.outputImage.cgImage

        let row = index / Self.inputImage.width
        let column = index % Self.inputImage.width

        return Self.inputGrayscaleImage
                   .window(forPixelAt: (x: column, y: row), takeCenter: true)
                   .vector
                   .map { Double($0) }
    }

    func output(at index: Int) -> [Double] {

        let row = index / Self.outputImage.width
        let column = index % Self.outputImage.width

        return [Double(Self.outputGrayscaleImage[column, row])]
    }
}

