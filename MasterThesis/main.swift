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
var imageG: Image<UInt8> = image.map { $0.gray }

imageG[imageG.width / 2, imageG.height / 2] = 0

let test = imageG.window(forPixelAt: (x: 0, y: 0))
let testV = Image<UInt8>(width: 3, height: 3, pixels: test.vector)

let asdf = testV.cgImage

print()
