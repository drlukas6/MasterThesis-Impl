//
//  LargeAutoencoderDataSet.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 13.07.2021..
//

import Foundation

struct LargeAutoEncoderDataSet {

    static let size = 4

    let dataset: [[Double]] = (0 ..< 16).map { index in Self.hotEncodedVector(at: index, ofLength: 16)} 

    private static func hotEncodedVector(at encodedIndex: Int, ofLength length: Int) -> [Double] {

        var vector = [Double](repeating: 0, count: length)

        vector[encodedIndex] = 255

        return vector
    }
}

