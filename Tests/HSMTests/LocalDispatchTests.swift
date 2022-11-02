//
//  LocalDispatchTests.swift
//  HSM
//
//  Created by Serhiy Butz on 04/19/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

// Locally dispatched event has to proceed over normally dispatched one

final class LocalDispatchTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = LocalDispatchHSM01(extended)

        // When

        sut.start()

        let exp1 = expectation(description: "")
        sut.dispatch(.scenario1(completion: {
            exp1.fulfill()
        }), completion: { XCTAssert($0) })

        //   +--------------------+
        //   |                    |
        //   |  #-----#  +-----+  |
        //   |  | S1  |  | S2  |  |
        //   |  |     |  |     |  |
        //   |  #-----#  +-----+  |
        //   |                    |
        //   +--------------------+

        // Then

        waitForExpectations(timeout: 3)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut.s2),
                        .entry(sut.s1)])

        // When

        extended.reset()

        let exp2 = expectation(description: "")
        sut.dispatch(.scenario2(completion: {
            exp2.fulfill()
        }), completion: { XCTAssert($0) })

        //   +--------------------+
        //   |                    |
        //   |  +-----+  #-----#  |
        //   |  | S1  |  | S2  |  |
        //   |  |     |  |     |  |
        //   |  +-----+  #-----#  |
        //   |                    |
        //   +--------------------+

        // Then

        waitForExpectations(timeout: 3)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut.s1),
                        .entry(sut.s2)])
    }
}
