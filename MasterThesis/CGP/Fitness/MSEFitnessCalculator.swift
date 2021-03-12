//
//  MSEFitnessCalculator.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

struct MSEFitnessCalculator: FitnessCalculator {

    func calculateFitness(fromPredictions predictions: [Double], groundTruth: [Double]) -> Double {

        // 1 / n * sum( (p - t) ^ 2 )

        zip(predictions, groundTruth)
            .map { prediction, trueValue in
                pow((prediction - trueValue), 2)
            }
            .reduce(0, +) / Double(predictions.count)
    }
}
