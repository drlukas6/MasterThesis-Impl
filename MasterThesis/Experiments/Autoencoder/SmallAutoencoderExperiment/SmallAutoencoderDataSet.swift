//
//  SmallAutoencoderDataSet.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 31.05.2021..
//

import Foundation

struct SmallAutoEncoderDataSet {

    static let size = 3

    var dataset: [[Double]] {[
        makeTopLeftCornerImage(),
        makeTopRightCornerImage(),
        makeBottomLeftCornerImage(),
        makeBottomRightCornerImage()
    ]}

    private func makeTopLeftCornerImage() -> [Double] {
        [255, 0, 0] +
        [0, 0, 0] +
        [0, 0, 0]
//        [255, 0] +
//        [0, 0]
    }

    private func makeTopRightCornerImage() -> [Double] {

        [0, 0, 255] +
        [0, 0, 0] +
        [0, 0, 0]
//
//        [0, 255] +
//        [0, 0]
    }


    private func makeBottomLeftCornerImage() -> [Double] {
        [0, 0, 0] +
        [0, 0, 0] +
        [255, 0, 0]
//        [0, 0] +
//        [255, 0]
    }

    private func makeBottomRightCornerImage() -> [Double] {
        [0, 0, 0] +
        [0, 0, 0] +
        [0, 0, 255]
//        [0, 0] +
//        [0, 255]
    }
}
