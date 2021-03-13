//
//  Experiment.swift
//  MasterThesis
//
//  Created by Lukas Sestic on 12.03.2021..
//

import Foundation

private extension String {

    static let experimentLogUrlPath = "MasterThesis/ExperimentLog.log"
}

protocol Experiment {

    var name: String { get }

    @discardableResult
    func start() -> CGPGraph
}

enum ExperimentStatus: String {

    case ok = "OK"
    case failed = "FAILED"
}

extension Experiment {

    private static var dateFormatter: DateFormatter {

        let formatter = DateFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .long

        return formatter
    }

    func log(withStatus status: ExperimentStatus, bestFitness fitness: Double, graphDescription: String) {

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