//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation
import SwiftImage

let experiment = EdgeDetectionTest()

experiment.startExperiment()

print()

//let defaultImageURL = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_512.jpg")!
//
//let inputImageURL = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lenacanny-full.jpg")!
//let inputImageURL = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_edges.png")!
//
//let defaultOutputImageURL = URL(fileURLWithPath: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_512_slice.jpg")
//
//let outputImageURL = URL(fileURLWithPath: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_edge_slice.png")
//
//
//let image: Image<RGB<UInt8>> = ImageLoader.load(from: defaultImageURL)!
//let image2: Image<RGB<UInt8>> = ImageLoader.load(from: inputImageURL)!
//
//
//let oneQuarterW = Int(Double(image.width) * 0.5)
//let oneQuarterH = Int(Double(image.width) * 0.5)
//
//let size = 40
//let step = size / 2
//
//let slice = image[oneQuarterW - step ..< oneQuarterW + step,
//                  oneQuarterH - step ..< oneQuarterH + step]
//
//let slice2 = image2[oneQuarterW - step ..< oneQuarterW + step,
//                    oneQuarterH - step ..< oneQuarterH + step]
//
//try! ImageHelper.save(image: Image<RGB<UInt8>>(slice), to: defaultOutputImageURL)
//try! ImageHelper.save(image: Image<RGB<UInt8>>(slice2), to: outputImageURL)
//
//
