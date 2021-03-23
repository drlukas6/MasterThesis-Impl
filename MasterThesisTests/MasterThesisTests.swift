//
//  MasterThesisTests.swift
//  MasterThesisTests
//
//  Created by Lukas Sestic on 24.03.2021..
//

@testable import MasterThesis

import SwiftImage
import XCTest

class MasterThesisTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {

        let lenaUrl = URL(string: "/Users/lukassestic/Developer/MasterThesis/Assets/lena.png")!

        let image: Image<RGB<UInt8>>? = ImageLoader.load(from: lenaUrl)

        XCTAssert(image != nil, "Failed to load Lena")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
