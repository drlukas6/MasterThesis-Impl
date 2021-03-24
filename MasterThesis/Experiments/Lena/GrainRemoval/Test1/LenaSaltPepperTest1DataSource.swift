//
//  LenaSaltPepperTest1DataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import SwiftImage

private extension URL {

    static let lenaSmallUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_small.png")!
    static let lenaSmallSPUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_small_salt_pepper.png")!
}

struct LenaSaltPepperTest1DataSource: Datasource {

    private static let inputImage: Image<RGB<UInt8>>! = ImageLoader.load(from: .lenaSmallSPUrl)
    private static let outputImage: Image<RGB<UInt8>>! = ImageLoader.load(from: .lenaSmallUrl)

    private static let inputGrayscaleImage: Image<UInt8> = inputImage.map { $0.gray }
    private static let outputGrayscaleImage: Image<UInt8> = outputImage.map { $0.gray }

    let size: Int = 900

    func input(at index: Int) -> [Double] {

        let row = index / Self.inputImage.width
        let column = index % Self.inputImage.width

        return Self.inputGrayscaleImage
                   .window(forPixelAt: (x: column, y: row), takeCenter: false)
                   .vector
                   .map { Double($0) }
    }

    func output(at index: Int) -> [Double] {

        let row = index / Self.outputImage.width
        let column = index % Self.outputImage.width

        return [Double(Self.outputGrayscaleImage[column, row])]
    }
}
