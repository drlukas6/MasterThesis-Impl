//
//  CGPNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

protocol CGPNode: AnyObject {

    var operation: CGPOperation { get set }

    var output: Double { get }
    var inputs: [Double] { get set }

    func calculateOutput()
}

