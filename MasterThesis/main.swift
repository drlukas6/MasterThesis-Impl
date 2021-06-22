//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//
import Foundation
import SwiftImage
import AppKit

for _ in 0 ..< 20 {
//    LargeSaltPepperExperiment().startExperiment()
SmallAutoencoderExperiment().startExperiment()
}

print(errCount)
print()

//let dna = [8, 1, 20, 2, 20, 0, 5, 1, 4, 6, 1, 0, 7, 5, 8, 0, 7, 1, 0, 1, 7, 6, 3, 11, 0, 8, 1, 6, 9, 6, 8, 6, 2, 2, 1, 4, 2, 3, 0, 9, 6, 1, 6, 0, 5, 6, 5, 7, 7, 10, 4, 6, 3, 9, 10, 6, 9, 11, 4, 12, 6, 11, 7, 8, 4, 7, 2, 5, 13, 3, 3, 0, 0, 7, 5, 8, 10, 5, 8, 9, 4, 8, 9, 3, 4, 10, 9, 5, 12, 10, 15, 11, 15, 15, 14, 2, 11, 3, 1, 14, 11, 4, 3, 10, 2, 8, 15, 7, 5, 3, 15, 16, 15, 6, 8, 1, 11, 0, 14, 4, 9, 9, 2, 9, 12, 11, 5, 8, 4, 16, 14, 0, 12, 18, 3, 2, 9, 15, 3, 20, 1, 4, 19, 6, 19, 11, 19, 6, 3, 7, 0, 4, 10, 7, 2, 2, 12, 16, 11, 1, 16, 18, 8, 2, 21, 13, 15, 5, 16, 25, 1, 24, 4, 15, 3, 0, 3, 10, 1, 1, 5, 2, 0, 12, 6, 10, 24, 6, 1, 21, 11, 26, 17, 1, 9, 8, 16, 25, 15, 11, 19, 2, 5, 2, 13, 25, 16, 4, 24, 14, 14, 15, 8, 11, 15, 28, 18, 13, 2, 14, 28, 4, 2, 20, 9, 29, 2, 3, 14, 27, 4, 12, 20, 12, 27, 21, 9, 22, 19, 0, 25, 16, 8, 18, 14, 20, 30, 6, 9, 18, 15, 0, 26, 17, 2, 15, 32, 3, 25, 5, 31, 9, 16, 15, 24, 25, 9, 34, 35, 22, 19, 9, 29, 29, 19, 9, 37, 22, 28, 4, 20, 13, 21, 6, 5, 7, 32, 18, 27, 25, 36, 30, 10, 7, 27, 20, 33, 7, 37, 27, 29, 36, 4, 4, 21, 18, 25, 15, 14, 20, 24, 4, 18, 6, 5, 29, 24, 12, 2, 35, 5, 3, 18, 13, 28, 8, 1, 24, 37, 1, 38, 9, 27, 41, 11, 13, 25, 9, 0, 15, 30, 9, 41, 38, 9, 27, 14, 3, 23, 13, 37, 39, 27, 15, 33, 22, 8, 24, 8, 13, 34, 38, 31, 32, 45, 46]
//let operationSet = LenaGrainRemovalOperationSet(numberOfInputs: 8)
//
//let cgp = CGPGraph(dna: dna, operationSet: operationSet)
//
//let url = URL(string: "/Users/lukassestic/Downloads/noisy_camerman.png")!
//
//let image2: Image<RGB<UInt8>> = ImageLoader.load(from: url)!
//let image: Image<UInt8> = image2.map(\.gray)
//
//let pixels = (0 ..< image.width * image.height).map { index -> UInt8 in
//
//    let row = index / image.width
//    let column = index % image.width
//
//    let window = image.window(forPixelAt: (x: column, y: row), takeCenter: false)
//                       .vector
//                       .map { Double($0) }
//
//    return UInt8(round(cgp.prediction(for: window).first!))
//}
//
//let newImage = Image(width: image.width, height: image.height, pixels: pixels)
//
//let pixels2 = (0 ..< image.width * image.height).map { index -> UInt8 in
//
//    let row = index / image.width
//    let column = index % image.width
//
//    let window = newImage.window(forPixelAt: (x: column, y: row), takeCenter: false)
//                       .vector
//                       .map { Double($0) }
//
//    return UInt8(round(cgp.prediction(for: window).first!))
//}
//
//let newImage2 = Image(width: image.width, height: image.height, pixels: pixels2)
//
//let cgimage = newImage2.cgImage
//let nsimage = NSImage(cgImage: cgimage, size: .init(width: image.width, height: image.height))
//
//print()
