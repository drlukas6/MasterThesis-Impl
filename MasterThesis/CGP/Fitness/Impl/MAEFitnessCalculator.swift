//
//  MAEFitnessCalculator.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 25.04.2021..
//

import Foundation

struct MAEFitnessCalculator: FitnessCalculator {

    func calculateFitness(fromPredictions predictions: [Double],
                          groundTruth: [Double]) -> (fitness: Double, error: Double) {

        let mae = zip(predictions, groundTruth)
                  .map { prediction, trueValue in abs(prediction - trueValue) }
                  .reduce(0, +) / Double(predictions.count)

        return (1 / mae, mae)
    }
}
