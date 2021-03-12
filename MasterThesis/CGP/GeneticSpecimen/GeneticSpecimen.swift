//
// Created by Lukas Sestic on 12.03.2021..
//

import Foundation

protocol GeneticSpecimen {

    associatedtype GeneType

    var dna: [GeneType] { get }

    func prediction(for inputs: [Double]) -> [Double]
}
