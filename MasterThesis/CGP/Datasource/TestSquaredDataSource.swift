//
//  TestSquaredDataSource.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

struct TestSquaredDataSource: Datasource {

    var inputs: [[Double]] = [[0], [0.5], [1], [1.5], [2]]
    var outputs: [[Double]] = [[0], [0.25], [1], [2.25], [4]]

    func makeSubDatasource(ofSize size: Int, offsetBy offset: Int) -> Datasource {

        var datasource = TestSquaredDataSource()

        let newInputs = (offset ..< offset + size).map { datasource.input(at: $0) }
        let newOutputs = (offset ..< offset + size).map { datasource.output(at: $0) }

        datasource.inputs = newInputs
        datasource.outputs = newOutputs

        return datasource
    }
}
