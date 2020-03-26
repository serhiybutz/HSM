//
//  TransitionTests.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class TransitionTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = TransitionHSM01(extended)

        // When

        sut.start()

        //    #--------------------#
        //    |                    |
        //    |  +-----+  +-----+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1))

        //    #-----+--------------#
        //    |     v              |
        //    |  #-----#  +-----+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  #-----#  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut.s1)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s2))

        //    #--------------------#
        //    |                    |
        //    |  +-----+  #-----#  |
        //    |  | S1  +->| S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  #-----#  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut))

        //    #--------------------#
        //    |              ^     |
        //    |  +-----+  +--+--+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1) {
            extended.transitionSequence.append(.handle(sut.s1))
        })

        //    #-----+--------------#
        //    |     v              |
        //    |  #-----#  +-----+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  #-----#  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s1),
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: nil) { // internal transition
            extended.transitionSequence.append(.handle(sut.s1))
        })

        //    #--------------------#
        //    |    +-v             |
        //    |  #-+---#  +-----+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  #-----#  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s1)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s2) {
            extended.transitionSequence.append(.handle(sut.s1))
        })

        //    #--------------------#
        //    |                    |
        //    |  +-----+  #-----#  |
        //    |  | S1  +->| S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  #-----#  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .handle(sut.s1),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: nil) { // internal transition
            extended.transitionSequence.append(.handle(sut.s2))
        })

        //    #--------------------#
        //    |             +-v    |
        //    |  +-----+  #-+---#  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  #-----#  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s2)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut) {
            extended.transitionSequence.append(.handle(sut))
        })

        //    #--------------------#
        //    |              ^     |
        //    |  +-----+  +--+--+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .handle(sut)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: nil) { // internal transition
            extended.transitionSequence.append(.handle(sut))
        })

        //    #--------------------#
        //    |                    |
        //    |  +-----+  +-----+  +-+
        //    |  | S1  |  | S2  |  | |
        //    |  |     |  |     |  |<+
        //    |  +-----+  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut)])
    }

    func test_02() {
        // Given

        let extended = Extended()
        let sut = TransitionHSM02(extended)

        // When

        sut.start()

        //    #-----------------------------#
        //    |     *                       |
        //    |  #--v--#  +-----+  +-----+  |
        //    |  | S1  |  | S2  |  | S3  |  |
        //    |  |     |  |     |  |     |  |
        //    |  #-----#  +--O--+  +-----+  |
        //    |              | always ^     |
        //    |              +--------+     |
        //    #-----------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut),
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s2) {
            extended.transitionSequence.append(.handle(sut))
        })

        //    #-----------------------------#
        //    |     *                       |
        //    |  +--v--+  +-----+  #-----#  |
        //    |  | S1  |  | S2  |  | S3  |  |
        //    |  |     +->|     |  |     |  |
        //    |  +-----+  +--O--+  #-----#  |
        //    |              | always ^     |
        //    |              +--------+     |
        //    #-----------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertTrue(sut.s3.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s3))

        print(extended.transitionSequence)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .handle(sut), // transition action
                        .entry(sut.s2),
                        .exit(sut.s2),
                        .always,
                        .entry(sut.s3)])
    }
}
