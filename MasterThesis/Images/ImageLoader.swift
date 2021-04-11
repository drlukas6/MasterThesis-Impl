//
//  ImageLoader.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import SwiftImage
import os.log

struct ImageLoader {

    private static let logger = Logger()

    static func load<T: _CGPixel>(from url: URL) -> Image<T>? {

        guard let image: Image<T> = Image(contentsOfFile: url.absoluteString) else {

            logger.error("Failed to load image from \(url.absoluteString)")

            return nil
        }

        logger.info("Successfully loaded image from \(url.absoluteString) with size W: \(image.width), H: \(image.height)")

        return image
    }

    static func loadGrayscale(from url: URL) -> Image<UInt8> {

        guard let image: Image<RGB<UInt8>> = load(from: url) else {
            fatalError("Please check input image type")
        }

        return image.map(\.gray)
    }
}
