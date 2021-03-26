//
//  L1FitnessCalculator.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 26.03.2021..
//

import Foundation

struct L1FitnessCalculator: FitnessCalculator {

    func calculateFitness(fromPredictions predictions: [Double],
                          groundTruth: [Double]) -> (fitness: Double, error: Double) {

        let mse = zip(predictions, groundTruth)
            .map { prediction, trueValue in
                abs(prediction - trueValue)
            }
            .reduce(0, +) / Double(predictions.count)

        return (1 / mse, mse)
    }
}
