//
//  History.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 28.03.2021..
//

import Foundation

class History {

    var fitnesses = [Double]()
    var errors = [Double]()

    var valErrors = [Double]()

    func add(fitness: Double, error: Double) {

        fitnesses.append(fitness)
        errors.append(error)
    }

    func add(valError: Double) {

        valErrors.append(valError)
    }
}
