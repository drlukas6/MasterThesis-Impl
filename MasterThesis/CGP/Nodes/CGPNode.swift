//
//  CGPNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

protocol CGPNode {

    var description: String { get }

    var output: Double { get }
    var inputs: [Double] { get set }

    func calculateOutput()
}
