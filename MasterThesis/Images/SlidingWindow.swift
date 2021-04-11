//
//  SlidingWindow.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import SwiftImage

struct ImageWindow {

    let vector: [UInt8]

    init(values: [[UInt8]]) {

        self.vector = values.flatMap { $0 }
    }
}

protocol ImageWindowProvider {

    func window(forPixelAt location: (x: Int, y: Int), takeCenter: Bool) -> ImageWindow
}

extension Image: ImageWindowProvider where Pixel == UInt8 {

    func window(forPixelAt location: (x: Int, y: Int), takeCenter: Bool = true) -> ImageWindow {

        let (x, y) = (location.x, location.y)

        let topLeft = self[(x - 1) %% width, (y - 1) %% height]
        let topCenter = self[x, (y - 1) %% height]
        let topRight = self[(x + 1) %% width, (y - 1) %% height]

        let centerLeft = self[(x - 1) %% width, y]
        let center = takeCenter ? self[x, y] : nil
        let centerRight = self[(x + 1) %% width, y]

        let bottomLeft = self[(x - 1) %% width, (y + 1) %% height]
        let bottomCenter = self[x, (y + 1) %% height]
        let bottomRight = self[(x + 1) %% width, (y + 1) %% height]

        let windowValues = [
            [topLeft, topCenter, topRight],
            [centerLeft, center, centerRight].compactMap { $0 }, // !< compactMap so if center is nil skip it
            [bottomLeft, bottomCenter, bottomRight]
        ]

        return .init(values: windowValues)
    }
}

extension ImageSlice: ImageWindowProvider where Pixel == UInt8 {

    func window(forPixelAt location: (x: Int, y: Int), takeCenter: Bool = true) -> ImageWindow {

        let (x, y) = (xRange.startIndex + location.x, yRange.startIndex + location.y)

        let topLeft = self[((x - 1) %% width) + xRange.startIndex,      ((y - 1) %% height) + yRange.startIndex]
        let topCenter = self[x,                                         ((y - 1) %% height) + yRange.startIndex]
        let topRight = self[((x + 1) %% width) + xRange.startIndex,     ((y - 1) %% height) + yRange.startIndex]

        let centerLeft = self[((x - 1) %% width) + xRange.startIndex,   y]
        let center = takeCenter ? self[x, y] : nil
        let centerRight = self[((x + 1) %% width) + xRange.startIndex,  y]

        let bottomLeft = self[((x - 1) %% width) + xRange.startIndex,   ((y + 1) %% height) + yRange.startIndex]
        let bottomCenter = self[x, ((y + 1) %% height) +                yRange.startIndex]
        let bottomRight = self[((x + 1) %% width) + xRange.startIndex,  ((y + 1) %% height) + yRange.startIndex]

        let windowValues = [
            [topLeft, topCenter, topRight],
            [centerLeft, center, centerRight].compactMap { $0 }, // !< compactMap so if center is nil skip it
            [bottomLeft, bottomCenter, bottomRight]
        ]

        return .init(values: windowValues)
    }
}

infix operator %%

private extension Int {

    static  func %% (_ left: Int, _ right: Int) -> Int {

        if left >= 0 { return left % right }

        if left >= -right { return (left+right) }

        return ((left % right)+right)%right
    }
}
