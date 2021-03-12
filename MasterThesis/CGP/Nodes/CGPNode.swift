//
//  CGPNode.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 17.02.2021..
//

protocol CGPNode: AnyObject {

    var operation: Operation { get set }

    var output: Double { get }
    var inputs: [Double] { get set }

    func calculateOutput()
}

extension CGPNode {

    var operation: Operation { .add }
}
