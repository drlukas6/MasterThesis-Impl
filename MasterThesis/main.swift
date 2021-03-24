//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation
import SwiftImage

let lenaUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena.png")!
let lenaSPUrl = URL(fileURLWithPath: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_salt_pepper.png")
let lenaSmallUrl = URL(fileURLWithPath: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_small.png")
let lenaSmallSPUrl = URL(fileURLWithPath: "/Users/lukassestic/Developer/MasterThesis/Assets/lena_small_salt_pepper.png")

let image: Image<RGB<UInt8>> = ImageLoader.load(from: lenaUrl)!
let imageG: Image<UInt8> = image.map { $0.gray }

let imageSlice = image[image.width / 2 - 15 ..< image.width / 2 + 15,
                  image.height / 2 - 15 ..< image.height / 2 + 15]

let cropped: Image<RGB<UInt8>> = Image(imageSlice)

do {
    try ImageHelper.save(image: cropped, to: lenaSmallUrl)
    try ImageHelper.save(image: ImageHelper.addSaltPepperNoise(to: cropped, withPercentage: 0.01),
                         to: lenaSmallSPUrl)
} catch {
    print("---> \(error)")
}
