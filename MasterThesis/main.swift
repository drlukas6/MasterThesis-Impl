//
//  main.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 10.02.2021..
//

import Foundation
import SwiftImage

let lenaUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena.png")!

let image: Image<RGB<UInt8>>? = ImageLoader.load(from: lenaUrl)

print()
