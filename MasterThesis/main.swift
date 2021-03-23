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

let image: Image<RGB<UInt8>> = ImageLoader.load(from: lenaUrl)!

let image2 = ImageHelper.addSaltPepperNoise(to: image, withPercentage: 0.03)

do {
    try ImageHelper.save(image: ImageHelper.addSaltPepperNoise(to: image, withPercentage: 0.01),
                          to: lenaSPUrl)
} catch {
    print("Error: \(error)")
}

print()
