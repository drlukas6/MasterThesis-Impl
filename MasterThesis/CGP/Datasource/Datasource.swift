//
//  Datasource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

protocol Datasource {

    var size: Int { get }

    func input(at index: Int) -> [Double]
    func output(at index: Int) -> [Double]

    func valInput(at index: Int) -> [Double]
    func valOutput(at index: Int) -> [Double]
}

extension Datasource {

    func valInput(at index: Int) -> [Double] { [] }
    func valOutput(at index: Int) -> [Double] { [] }
}
