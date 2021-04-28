//
//  ImageHelper.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import SwiftImage

struct ImageHelper {

    static func addSaltPepperNoise(to image: Image<RGB<UInt8>>, withPercentage percentage: Double) -> Image<RGB<UInt8>> {

        image.map { pixel in

            guard Double.random(in: 0...1) <= percentage else {
                return pixel
            }

            return Bool.random() ? RGB.white : RGB.black
        }
    }

    static func save<T: _CGPixel>(image: Image<T>, withFormat format: ImageFormat = .png, to url: URL) throws {
        try image.data(using: format)?.write(to: url)
    }
}

extension Image {

    var pixelVector: [Pixel] {
        map { $0 }
    }
}
