//
//  GeneticPopulation.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

class CGPPopulation {

    struct GraphParameters {

        let inputs: Int
        let outputs: Int
        let levelsBack: Int
        let dimension: CGPGraph.Size
    }

    struct PopulationParameters {

        let populationSize: Int
        let mutationRate: Double
    }

    var population: [CGPGraph]!

    init(populationParameters: PopulationParameters, graphParameters: GraphParameters) {

        
    }
}
