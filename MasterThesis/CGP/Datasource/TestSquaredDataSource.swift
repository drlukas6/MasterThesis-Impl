//
//  TestSquaredDataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

struct TestSquaredDataSource: Datasource {

    let inputs: [[Double]] = [[0], [0.5], [1], [1.5], [2]]
    let outputs: [[Double]] = [[0], [0.25], [1], [2.25], [4]]
}
