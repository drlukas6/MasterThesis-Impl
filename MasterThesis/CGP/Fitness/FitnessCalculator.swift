//
//  FitnessCalculator.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

protocol FitnessCalculator {

    func calculateFitness(fromPredictions predictions: [Double],
                          groundTruth: [Double]) -> (fitness: Double, error: Double)
}
