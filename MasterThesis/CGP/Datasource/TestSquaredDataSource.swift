//
//  TestSquaredDataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

struct TestSquaredDataSource: Datasource {

    let inputs: [[Double]] = [[-2], [-1.5], [-1], [-0.5], [0], [0.5], [1], [1.5], [2]]
    let outputs: [Double] = [4, 2.25, 1, 0.25, 0, 0.25, 1, 2.25, 4]
}
