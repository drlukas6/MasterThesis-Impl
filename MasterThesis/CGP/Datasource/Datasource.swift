//
//  Datasource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

protocol Datasource {

    var inputs: [[Double]] { get }
    var outputs: [Double] { get }
}

extension Datasource {

    func input(at index: Int) -> [Double] {
        inputs[index]
    }
    func output(at index: Int) -> Double {
        outputs[index]
    }

    func row(at index: Int) -> ([Double], Double) {
        (input(at: index), output(at: index))
    }
}
