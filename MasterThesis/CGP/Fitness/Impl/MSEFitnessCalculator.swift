//
//  MSEFitnessCalculator.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation
import Accelerate

struct MSEFitnessCalculator: FitnessCalculator {

    func calculateFitness(fromPredictions predictions: [Double],
                          groundTruth: [Double]) -> (fitness: Double, error: Double) {

        let mse = zip(predictions, groundTruth)
            .map { prediction, trueValue in
                pow((abs(prediction - trueValue)), 2) // TODO : tu je bilo 2
            }
            .reduce(0, +) / Double(predictions.count)

        return (1 / mse, mse)
    }
}
