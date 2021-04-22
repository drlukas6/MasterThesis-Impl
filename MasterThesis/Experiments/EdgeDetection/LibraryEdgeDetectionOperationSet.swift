//
//  LibraryEdgeDetectionOperationSet.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 18.04.2021..
//

import Darwin

struct LibraryEdgeDetectionOperationSet: CGPOperationSet {

    var operations: [CGPOperation] {
        LibraryEdgeDetectionOperation.allCases
    }

    let numberOfInputs = 9
}

enum LibraryEdgeDetectionOperation: CaseIterable, CGPOperation {

    case constant
    case identity
    case inversion
    case or
    case negativeOr
    case and
    case nand
    case xor
    case rightShift1
    case rightShift2
    case swap
    case add
    case average
    case max
    case min

    var inputs: Int {
        2
    }

    func execute(with input: [Double]) -> Double {

        switch self {
        case .constant:     return 255
        case .identity:     return input[0]
        case .inversion:    return 255 - input[0]
        case .or:           return Double(UInt8(round(input[0])) | UInt8(round(input[1])))
        case .negativeOr:   return Double(~UInt8(round(input[0])) | UInt8(round(input[1])))
        case .and:          return Double(UInt8(round(input[0])) & UInt8(round(input[1])))
        case .nand:         return Double(~(UInt8(round(input[0])) & UInt8(round(input[1]))))
        case .xor:          return Double(UInt8(round(input[0])) ^ UInt8(round(input[1])))
        case .rightShift1:  return Double(UInt8(round(input[0])) >> 1)
        case .rightShift2:  return Double(UInt8(round(input[0])) >> 2)
        case .swap:         return Double((UInt8(round(input[0])) & 0x0F) << 4 | (UInt8(round(input[0])) & 0xF0) >> 4)
        case .add:          return Double(UInt8(round(input[0])) &+ UInt8(round(input[1])))
        case .average:      return Double(input.reduce(0, +)) / Double(input.count)
        case .max:          return input.max()!
        case .min:          return input.min()!
        }
    }

    func isEqual(to rhs: CGPOperation) -> Bool {

        guard let rhs = rhs as? LibraryEdgeDetectionOperation else {
            return false
        }

        return self == rhs
    }
}

