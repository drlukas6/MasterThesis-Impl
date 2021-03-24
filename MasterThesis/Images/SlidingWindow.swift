//
//  SlidingWindow.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 24.03.2021..
//

import Foundation
import SwiftImage

struct ImageWindow {

    let values: [[UInt8]]

    var vector: [UInt8] {
        [values[0][0], values[0][1], values[0][2],
         values[1][0], values[1][1], values[1][2],
         values[2][0], values[2][1], values[2][2]]
    }
}

extension Image where Pixel == UInt8 {

    func window(forPixelAt location: (x: Int, y: Int)) -> ImageWindow {

        let (x, y) = (location.x, location.y)

        let topLeft = self[(x - 1) %% width, (y - 1) %% height]
        let topCenter = self[x, (y - 1) %% height]
        let topRight = self[(x + 1) %% width, (y - 1) %% height]

        let centerLeft = self[(x - 1) %% width, y]
        let center = self[x, y]
        let centerRight = self[(x + 1) %% width, y]

        let bottomLeft = self[(x - 1) %% width, (y + 1) %% height]
        let bottomCenter = self[x, (y + 1) %% height]
        let bottomRight = self[(x + 1) %% width, (y + 1) %% height]

        let windowValues = [
            [topLeft, topCenter, topRight],
            [centerLeft, center, centerRight],
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
