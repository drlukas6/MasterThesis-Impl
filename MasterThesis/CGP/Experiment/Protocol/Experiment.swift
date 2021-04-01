//
//  Experiment.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation
import os.log

private extension String {

    static let experimentLogUrlPath = "MasterThesis/ExperimentLog.log"
    static let historyUrlPath = "MasterThesis/.history"
}

protocol Experiment {

    var name: String { get }

    @discardableResult
    func work() -> (CGPGraph, History)
}

extension Experiment {

    private static var dateFormatter: DateFormatter {

        let formatter = DateFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .long

        return formatter
    }

    @discardableResult
    func startExperiment() -> CGPGraph {

        let startDate = Date()

        let (best, history) = work()

        let duration = Date().timeIntervalSince(startDate) * 1000

        Logger().info("\nExperiment finished in \(duration)ms")

        log(withStatus: .ok,
            bestFitness: best.fitness,
            graphDescription: best.graphDescription)

        log(history: history)

        return best
    }

    private func log(withStatus status: ExperimentStatus, bestFitness fitness: Double, graphDescription: String) {

        let developerDirectory = FileManager.default.urls(for: .developerDirectory, in: .userDomainMask).first!

        let logUrl = developerDirectory.appendingPathComponent(.experimentLogUrlPath)

        let fitnessString = String(format: "~%.3f", fitness)
        let dateKey = Self.dateFormatter.string(from: Date())

        let logEntry = "\(dateKey) [\(name)] \(status.rawValue): FITNESS: \(fitnessString) DESCRIPTION: \(graphDescription)"

        do {
            try logEntry.appendLineToURL(fileURL: logUrl)
        } catch {
            print("Error writing to file: \(error.localizedDescription)")
        }
    }

    private func log(history: History) {

        let developerDirectory = FileManager.default.urls(for: .developerDirectory, in: .userDomainMask).first!

        let historyUrl = developerDirectory.appendingPathComponent(.historyUrlPath)

        do {
            try history.fitnesses.map { String($0) }.joined(separator: " ").appendLineToURL(fileURL: historyUrl)
            try history.errors.map { String($0) }.joined(separator: " ").appendLineToURL(fileURL: historyUrl)
        } catch {
            print("Error writing to file: \(error.localizedDescription)")
        }
    }

    private func showGraph() {

        let task = Process()

        task.launchPath = "python3"
        task.arguments = ["show_graph.py"]

        task.launch()
    }
}


enum ExperimentStatus: String {

    case ok = "OK"
    case failed = "FAILED"
}

private extension String {

    func appendLineToURL(fileURL: URL) throws {
         try (self + "\n").appendToURL(fileURL: fileURL)
     }

     func appendToURL(fileURL: URL) throws {

         let data = self.data(using: String.Encoding.utf8)!

         try data.append(fileURL: fileURL)
     }
 }

 extension Data {

     func append(fileURL: URL) throws {

         if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {

             defer {
                 fileHandle.closeFile()
             }

             fileHandle.seekToEndOfFile()
             fileHandle.write(self)
         } else {
             try write(to: fileURL, options: .atomic)
         }
     }
 }
